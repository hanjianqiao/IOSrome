//
//  huitaoShopViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/1/13.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

class huitaoShopViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    var jsString: String?
    var targetUrl: String?
    var jsContext: JSContext?
    var url:String = ""
    
    
    @IBAction func copyToken(_ sender: UIBarButtonItem) {
        let function = jsContext?.objectForKeyedSubscript("copyToken")
        let tokenString = function?.call(withArguments: [""])
        if(tokenString == nil || tokenString?.toString() == ""){
            let alert = UIAlertController (title: "获取失败", message: "没有找到目标"
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            UIPasteboard.general.string = tokenString?.toString()!
            let alert = UIAlertController (title: "获取成功", message: UIPasteboard.general.string
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationItem.title = AppStatus.sharedInstance.isVip ? "快淘一下" : "购买VIP查看数据"
        
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
        
        webView.delegate = self
        let url:URL = URL(string: self.url)!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: jsString!)
        
        jsContext = (webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext)
        let model = SwiftJavaScriptModel()
        model.controller = self
        jsContext?.setObject(model, forKeyedSubscript: "LanJsBridge" as (NSCopying & NSObjectProtocol)?)
        model.jsContext = jsContext
        jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception: ", exception ?? "No")
        }
        
        if(webView.request?.url?.absoluteString.contains("alimama.com"))!{
            webView.stringByEvaluatingJavaScript(from: "var element = document.createElement('meta');  element.name = \"viewport\";  element.content = \"width=device-width,initial-scale=0.6,minimum-scale=0.6,maximum-scale=0.6,user-scalable=0.6\"; var head = document.getElementsByTagName('head')[0]; head.appendChild(element);")
        }
        
        //let function = jsContext?.objectForKeyedSubscript("doWork")
        //_ = function?.call(withArguments: [targetUrl ?? "", AppStatus.sharedInstance.isVip])
        print("loading finish...")
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
