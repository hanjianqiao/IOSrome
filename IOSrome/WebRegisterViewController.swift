//
//  WebRegisterViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/3/2.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

class WebRegisterViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*
         * Main web page
         *
         */
        //let serverUrlString = AppStatus.sharedInstance.server.address + AppStatus.sharedInstance.server.port + AppStatus.sharedInstance.path.selfchoose
        webView.scalesPageToFit = true
        //webView.loadRequest(request)
        webView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        if let path = Bundle.main.path(forResource: "message", ofType: "html") {
            webView.loadRequest( URLRequest(url: URL(fileURLWithPath: path)) )
        }
    }
    
    func showDetail(id:String){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "message_detail"))! as! SystemMessageDetailViewController
        vc.messageId = id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            let para:[String] = url.components(separatedBy: ":")
            if(para[1] == "showDetail"){
                showDetail(id: para[2])
            }
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
