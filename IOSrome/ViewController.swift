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
    func getDataFromUrl(_ urlString: String, _ callBack: String)
    func getDataFromUrlWithCookie(_ urlString: String, _ callBack: String, _ cookieFor: String)
}
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate{
    internal func getDataFromUrlWithCookie(_ urlString: String, _ callBack: String, _ cookieFor: String) {
        let url:URL = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            if let data = data, let html = String(data: data, encoding: String.Encoding.utf8){
                let function = self.jsContext?.objectForKeyedSubscript(callBack)
                let result = function?.call(withArguments: [html])
                print(result ?? "No result!")
            }
        }
        task.resume()
    }

    internal func getDataFromUrl(_ urlString: String, _ callBack: String){
        let url:URL = URL(string: urlString)!
        var html: String? = nil
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
                html = String(data: data!, encoding: String.Encoding.utf8)
                semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        let function = jsContext?.objectForKeyedSubscript(callBack)
        _ = function?.call(withArguments: [html ?? ""])
    }

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
    
    var jsString: String?
    var jsContext: JSContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
         * Inject javaScript
         *
         *
         */
        do{
            let filePath = Bundle.main.path(forResource: "lanjs", ofType: "js")
            try jsString = String(contentsOfFile: filePath!)
        }catch let err as NSError{
            print(err)
        }
        
        /*
         * Do cookie manipulation
         *
         */
        let instanceOfCustomObject: CustomObject = CustomObject()
        instanceOfCustomObject.someMethod()
        
        
        /*
         * Main web page
         *
         */
        let url:URL = URL(string: "http://m.taobao.com")!
        
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

    
    /**
     ** Buttons
     **
     **/
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
    

    
    /**
     **
     ** Called when start to load a page
     **
     **/
    func webViewDidStartLoad(_ webView: UIWebView) {
        searchBar.text = webView.request?.url?.absoluteString
        print("Start loading...")
        /*
        let url = URL(string: "http://zhushou3.taokezhushou.com")
        let cookies = HTTPCookieStorage.shared.cookies(for: url!)
        for cookie in cookies!{
            print(cookie)
        }
        print("end cookies")
        */
    }
    
    
    /**
     **
     ** Called when finish loading a page
     **
     **
     **/
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webView.stringByEvaluatingJavaScript(from: jsString!)
        
        /* 
         * 
         * Setup bridge to let swift and javascript communicate
         *
         */
        jsContext = (webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext)
        let model = SwiftJavaScriptModel()
        model.controller = self
        jsContext?.setObject(model, forKeyedSubscript: "LanJsBridge" as (NSCopying & NSObjectProtocol)!)
        model.jsContext = jsContext
        jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception: ", exception ?? "No")
        }
        
        
        /*
         * Ways to call birdge functions
         let result0 = webView.stringByEvaluatingJavaScript(from: "imgAutoFit(\"Java\", \"webview\")")
         let result1 = jsContext.evaluateScript("imgAutoFit('Java', 'context')")
         let function = jsContext.objectForKeyedSubscript("imgAutoFit")
         let result2 = function?.call(withArguments: ["Hello", "forfunction"])
         NSLog(result0!)
         NSLog((result1?.toString())!)
         NSLog((result2?.toString())!)
        */
        
        
        print("Finish loading...")
        /*
         * Do main work
         *
         */
        webView.stringByEvaluatingJavaScript(from: "doWork()")
    }
    
    
    /**
     **
     ** When failed to load a requested url
     **
     **
     **/
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Failed in loading...")
    }
    
    /**
     ** Filter request url
     **
     **
     **/
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
    
    /**
     ** Other functions
     **
     **
     **/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

