//
//  ViewController.swift
//  IOSrome
//
//  Created by Lanchitour on 2016/11/18.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol SwiftJavaScriptDelegate: JSExport{
    func test0() -> String
    func test1(_ para: String ) -> String
    func test2(_ para0:String,_ para1:String) -> String
    func have(_ a: String,_ b:String)->String
}
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate{
    internal func have(_ a: String,_ b: String) -> String {
        print(a+b)
        return "have"
    }

     func test2(_ para0: String,_ para1: String) -> String {
        NSLog("Function test2 " + para0 + " " + para1)
        return para1
    }

    func test1(_ para:String) -> String {
        NSLog("Function test1 ")
        return "hj"
    }

    internal func test0() -> String {
        NSLog("Function test 0")
        return "Test0"
    }

    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
}

class ViewController: UIViewController, UIWebViewDelegate, UISearchBarDelegate  {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let url:URL = URL(string: "http://www.baidu.com")!
        let request:URLRequest = URLRequest(url: url)
        
        webView.loadRequest(request)
        searchBar.delegate = self
        webView.delegate = self
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var str = searchBar.text!
        if !str.hasPrefix("http://"){
            
            str = str.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            str = "http://www.baidu.com/s?word="+str
        }
        let url = URL(string: str)!
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        self.view.endEditing(true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func homeButton(_ sender: UIButton) {
        let url:URL = URL(string: "http://www.baidu.com")!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    @IBAction func taobaoButton(_ sender: UIButton) {
        let url:URL = URL(string: "http://m.taobao.com")!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
    }
    

    func webViewDidStartLoad(_ webView: UIWebView) {
        searchBar.text = webView.request?.url?.absoluteString
        print("Start loading...")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let js = "function imgAutoFit(a, b){WebViewJavaScriptBridge1.test0();WebViewJavaScriptBridge1.test1('a');WebViewJavaScriptBridge1.have('a','b');return b;}"
        webView.stringByEvaluatingJavaScript(from: js)
        
        let jsContext:JSContext = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        let model = SwiftJavaScriptModel()
        model.controller = self
        model.jsContext = jsContext
        jsContext.setObject(model, forKeyedSubscript: "WebViewJavaScriptBridge1" as (NSCopying & NSObjectProtocol)!)
        
        
        jsContext.exceptionHandler = {
            (context, exception) in
            print("exception: ", exception ?? "No")
        }
        
        let result0 = webView.stringByEvaluatingJavaScript(from: "imgAutoFit(\"Java\", \"webview\")")
        let result1 = jsContext.evaluateScript("imgAutoFit('Java', 'context')")
        let function = jsContext.objectForKeyedSubscript("imgAutoFit")
        let result2 = function?.call(withArguments: ["Hello", "forfunction"])
        
        
        NSLog(result0!)
        NSLog((result1?.toString())!)
        NSLog((result2?.toString())!)
        
        print("Finish loading...")
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Failed in loading...")
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.scheme?.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let method:String = (request.url?.absoluteString.substring(from: startIndex))!
            let parameters:[String] = method.components(separatedBy: ":")
            let selector:Selector = NSSelectorFromString(parameters[0])
            if self.responds(to: selector){
                let control: UIControl = UIControl()
                control.sendAction(selector, to: self, for: nil)
            }
            NSLog("IOS call")
            return false
        }
        print(request.url?.scheme ?? "Error request url");
        return true
    }
    func hello() -> String{
        NSLog("Hello without patameter");
        return "Hello JavaScript no parameter"
    }
}

