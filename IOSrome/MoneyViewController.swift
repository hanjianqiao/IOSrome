//
//  MoneyViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/1/14.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

class MoneyViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url:URL = URL(string: AppStatus.sharedInstance.contentServer.money)!
        
        let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.delegate = self
    }
    var id:String = ""
    func showList(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "invitation_list"))! as! InvitationListViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            let para:[String] = url.components(separatedBy: ":")
            if(para[1] == "charge"){
                charge()
            }
            return false
        }else if(request.url?.absoluteString.hasPrefix("list"))!{
            showList()
            return false
        }
        print(request.url ?? "Error request url");
        return true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var jsContext: JSContext?
    func webViewDidFinishLoad(_ webView: UIWebView) {
        jsContext = (webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext)
        let model = SwiftJavaScriptModel()
        model.controller = self
        jsContext?.setObject(model, forKeyedSubscript: "LanJsBridge" as (NSCopying & NSObjectProtocol)!)
        model.jsContext = jsContext
        jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception: ", exception ?? "No")
        }
        let function = jsContext?.objectForKeyedSubscript("updateDisplay")
        _ = function?.call(withArguments: [AppStatus.sharedInstance.userInfo.userId, AppStatus.sharedInstance.userInfo.password])
    }
    

    
    func getQueryStrByDic(dic:[(String,String)])->String{
        var pars = ""
        for (index, element) in dic.enumerated() {
            if(index == 0){
                pars += "\(element.0)=\(element.1)";
            }else{
                pars += "&\(element.0)=\(element.1)";
            }
        }
        return pars;
    }
    
    func getSign(dic:Dictionary<String,String>,key:String) -> String{
        var sign:String = ""
        let dicNew = dic.sorted { (a, b) -> Bool in
            return a.0 < b.0
        }
        
        sign = getQueryStrByDic(dic: dicNew)
        sign += "&key=\(key)"
        print(sign)
        sign = (sign.MD5?.uppercased())!
        print(sign)
        return sign
    }

    let serverUrlString = AppStatus.sharedInstance.userServer.charge_url
    func charge() {
        print("Buy vip...")
        let payRequest = PayReq()
        payRequest.partnerId = "10000100"
        payRequest.prepayId = "1101000000140415649af9fc314aa427"
        payRequest.package = "Sign=WXPay"
        payRequest.nonceStr = "a462b76e7436e98e0ed6e13c64b4fd1c"
        payRequest.timeStamp = UInt32(NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970)
        
        var dic:[String:String] = [:]
        dic["appid"] = AppStatus.sharedInstance.wechatAPPID
        dic["prepayid"] = payRequest.prepayId
        dic["package"] = payRequest.package
        dic["noncestr"] = payRequest.nonceStr
        dic["timestamp"] = "\(payRequest.timeStamp)"
        
        let sign = self.getSign(dic: dic, key: AppStatus.sharedInstance.wechatPayKey)
        
        payRequest.sign = sign
        
        WXApi.send(payRequest)
        
        let queue = OperationQueue()
        
        // do something immediately
        let alertLogging = UIAlertController (title: "充值中", message: "请稍后。。。"
            , preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertLogging, animated: true, completion: nil)
        
        queue.addOperation() {
            // do something in the background
            var request = URLRequest(url: URL(string: self.serverUrlString)!)
            request.httpMethod = "POST"
            let postString = "{\"user_id\":\"" +
                AppStatus.sharedInstance.userInfo.userId + "\",\"password\":\"" +
                AppStatus.sharedInstance.userInfo.password + "\"}"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                
                guard let data = data, error == nil else {               // check for fundamental networking error
                    print("error=\(error)")
                    alertLogging.dismiss(animated: true, completion:{
                        OperationQueue.main.addOperation {
                            alertLogging.dismiss(animated: true, completion: nil)
                            let alert = UIAlertController (title: "网络异常", message: "请重新充值"
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                //print(data)
                let responseString = String(data: data, encoding: .utf8)!
                print("responseString = \(responseString)")
                
                let json = JsonTools.convertToDictionary(text: responseString)!
                
                print(json["status"] as! String == "ok")
                print(json["message"]!)
                OperationQueue.main.addOperation {
                    self.webView.reload()
                    alertLogging.dismiss(animated: true, completion:{
                        NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: nil)
                        alertLogging.dismiss(animated: true, completion: nil)
                        let alert = UIAlertController (title: "充值结果", message: json["message"] as? String
                            , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    })
                }
            }
            task.resume()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
