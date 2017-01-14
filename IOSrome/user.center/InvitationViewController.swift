//
//  InvitationViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/1/4.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

class InvitationViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*
         * Main web page
         *
         */
        //let serverUrlString = AppStatus.sharedInstance.server.address + AppStatus.sharedInstance.server.port + AppStatus.sharedInstance.path.selfchoose
        var serverUrlString:String
        print("user level: \(AppStatus.sharedInstance.userInfo.level)")
        if(AppStatus.sharedInstance.userInfo.level == "user" || AppStatus.sharedInstance.userInfo.level == "vip"){
            serverUrlString = AppStatus.sharedInstance.contentServer.agentPageURL1
        }else{
            serverUrlString = AppStatus.sharedInstance.contentServer.agentPageURL2
        }
        let url:URL = URL(string: serverUrlString)!
        
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
    func buyCom(com:String){
        let queue = OperationQueue()
        // do something immediately
        let alertLogging = UIAlertController (title: "购买套餐", message: "请稍后。。。"
            , preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertLogging, animated: true, completion: nil)
        queue.addOperation() {
            // do something in the background
            var request = URLRequest(url: URL(string: AppStatus.sharedInstance.userServer.extendagent_url)!)
            request.httpMethod = "POST"
            let postString = "{\"user_id\":\"" +
                AppStatus.sharedInstance.userInfo.userId + "\",\"password\":\"" +
                AppStatus.sharedInstance.userInfo.password + "\",\"combo\":\"" +
                com + "\"}"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                
                guard let data = data, error == nil else {               // check for fundamental networking error
                    print("error=\(error)")
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
                
                print(json["status"] as! String == "failed")
                print(json["message"]!)
                
                OperationQueue.main.addOperation {
                    alertLogging.dismiss(animated: true, completion:{
                        if(json["status"] as! String == "ok"){
                            let alert = UIAlertController (title: "套餐购买成功", message: responseString
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(UIAlertAction)->Void in
                                let url:URL = URL(string: AppStatus.sharedInstance.contentServer.agentPageURL2)!
                                let request:URLRequest = URLRequest(url: url)
                                self.webView.loadRequest(request)}))
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = UIAlertController (title: "购买请求失败", message: responseString
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
            task.resume()
        }
        
        /*
         let xml = SWXMLHash.parse(postString)
         
         for i in xml.children{
         for j in i.children{
         print(j.element?.text! ?? "")
         }
         }
         //print(xml)
         */
        
        //AppStatus.sharedInstance.isVip = true
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            let para:[String] = url.components(separatedBy: ":")
            if(para[1] == "buycom"){
                buyCom(com: para[2])
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
