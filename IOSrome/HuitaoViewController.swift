//
//  HuitaoViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/11.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

class HuitaoViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var jsString: String?
    var targetUrl: String?
    var jsContext: JSContext?

    @IBAction func copyToken(_ sender: UIBarButtonItem) {
        let function = jsContext?.objectForKeyedSubscript("copyToken")
        let tokenString = function?.call(withArguments: [""])
        if(tokenString == nil){
            return
        }else{
            print("Token is:\n\(tokenString!)")
            UIPasteboard.general.string = tokenString?.toString()!
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = AppStatus.sharedInstance.isVip ? "会淘一下" : "购买VIP查看数据"
        
        do{
            let filePath = Bundle.main.path(forResource: "lanjs_s", ofType: "js")
            try jsString = String(contentsOfFile: filePath!)
        }catch let err as NSError{
            print(err)
        }
        /*
         * Main web page
         *
         */
        
        
        let url:URL = URL(string: AppStatus.sharedInstance.contentServer.kuaitaoPageURL)!
        let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        webView.delegate = self
        webView.loadRequest(request)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: jsString!)
 
        jsContext = (webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext)
        let model = SwiftJavaScriptModel()
        model.controller = self
        jsContext?.setObject(model, forKeyedSubscript: "LanJsBridge" as (NSCopying & NSObjectProtocol)!)
        model.jsContext = jsContext
        jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception: ", exception ?? "No")
        }
        
        if(webView.request?.url?.absoluteString.contains("alimama.com"))!{
            webView.stringByEvaluatingJavaScript(from: "var element = document.createElement('meta');  element.name = \"viewport\";  element.content = \"width=device-width,initial-scale=0.6,minimum-scale=0.6,maximum-scale=0.6,user-scalable=0.6\"; var head = document.getElementsByTagName('head')[0]; head.appendChild(element);")
        }
        //print(webView.request?.url?.absoluteString)
        let function = jsContext?.objectForKeyedSubscript("doWork")
        _ = function?.call(withArguments: [targetUrl ?? "", AppStatus.sharedInstance.isVip])
        print("loading finish...")
        //webView.scrollView.setZoomScale(0.1, animated: true)
        //webView.stringByEvaluatingJavaScript(from: "doWork()")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var taoDetail:String = ""
    func showTaobaoDetail(){
        NotificationCenter.default.post(name: Notification.Name("noti_load_page"), object: self, userInfo: ["url":taoDetail])
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let method:String = (request.url?.absoluteString.substring(from: startIndex))!
            let parameters:[String] = method.components(separatedBy: ":")
            let selector:Selector = NSSelectorFromString(parameters[0])
            taoDetail = parameters[1]+":"+parameters[2]
            if self.responds(to: selector){
                let control: UIControl = UIControl()
                control.sendAction(selector, to: self, for: nil)
            }
            NSLog("IOS call")
            return false
        } else if (request.url?.absoluteString.hasPrefix("clipboard"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let dataStr:String = (request.url?.absoluteString.substring(from: startIndex))!
            UIPasteboard.general.string = dataStr;
            let alert = UIAlertController (title: "已复制链接", message: UIPasteboard.general.string
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
        
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
