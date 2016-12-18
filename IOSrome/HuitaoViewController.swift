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
        print("Token is: \(tokenString!)")
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
        
        //let url:URL = URL(string: "http://kouchenvip.com:5000/recommend")!
        
        webView.scalesPageToFit = true
        
        let staticHTML = "<html><head><meta http-equiv=\"Content-Language\"content=\"zh-CN\"><meta HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html;charset=UTF-8\"><title>会淘助手</title></head><body><section id=\"lanSec\">hellowor</section></body></html>"
        webView.loadHTMLString(staticHTML, baseURL: nil)
        
        //let request:URLRequest = URLRequest(url: url)
        //webView.loadRequest(request)

        webView.delegate = self
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
        
        let function = jsContext?.objectForKeyedSubscript("doWork")
        _ = function?.call(withArguments: [targetUrl ?? "", true])
        print("loading finish...")
        //webView.scrollView.setZoomScale(0.1, animated: true)
        //webView.stringByEvaluatingJavaScript(from: "doWork()")
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
