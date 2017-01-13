//
//  VIPDetailViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/14.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class VIPDetailViewController: UIViewController, UIWebViewDelegate {
    
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
        if(AppStatus.sharedInstance.userInfo.level == "user"){
            serverUrlString = AppStatus.sharedInstance.contentServer.vipPageURL1
        }else{
            serverUrlString = AppStatus.sharedInstance.contentServer.vipPageURL3
        }
        let url:URL = URL(string: serverUrlString)!
        
        let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.delegate = self
    }
        
    func buyvip(){
        let queue = OperationQueue()
        // do something immediately
        let alertLogging = UIAlertController (title: "购买VIP", message: "请稍后。。。"
            , preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertLogging, animated: true, completion: nil)
        queue.addOperation() {
            // do something in the background
            var request = URLRequest(url: URL(string: AppStatus.sharedInstance.userServer.up2vip_url)!)
            request.httpMethod = "POST"
            let postString = "{\"user_id\":\"" +
                AppStatus.sharedInstance.userInfo.userId + "\",\"password\":\"" +
                AppStatus.sharedInstance.userInfo.password + "\"}"
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
                            let url:URL = URL(string: AppStatus.sharedInstance.contentServer.vipPageURL3)!
                            let request:URLRequest = URLRequest(url: url)
                            self.webView.loadRequest(request)
                        }else{
                            alertLogging.dismiss(animated: true, completion: nil)
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
    
    func extendvip(month:Int){
        let queue = OperationQueue()
        // do something immediately
        let alertLogging = UIAlertController (title: "购买VIP", message: "请稍后。。。"
            , preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertLogging, animated: true, completion: nil)
        queue.addOperation() {
            // do something in the background
            var request = URLRequest(url: URL(string: AppStatus.sharedInstance.userServer.extendvip_url)!)
            request.httpMethod = "POST"
            let postString = "{\"user_id\":\"" +
                AppStatus.sharedInstance.userInfo.userId + "\",\"password\":\"" +
                AppStatus.sharedInstance.userInfo.password + "\",\"month\":\"" +
                String(month) + "\"}"
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
                            let alert = UIAlertController (title: "续费成功", message: responseString
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(UIAlertAction)->Void in
                                let url:URL = URL(string: AppStatus.sharedInstance.contentServer.vipPageURL3)!
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
            if(para[1] == "buy"){
                buyvip()
            }else if(para[1] == "extend"){
                let month = Int(para[2])
                extendvip(month: month!)
            }
            return false
        }else if(request.url?.absoluteString.hasPrefix("lanalert"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let method:String = (request.url?.absoluteString.substring(from: startIndex))!
            let alert = UIAlertController (title: "登陆结果", message: method.removingPercentEncoding
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        print(request.url ?? "Error request url");
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
