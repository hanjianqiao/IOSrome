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
    func getDataFromUrl2(_ urlString: String, _ callBack: String)
    func getClipBoart(_ string: String)
}
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate, URLSessionDelegate{
    internal func getClipBoart(_ string: String) {
        UIPasteboard.general.string = string;
    }

    internal func getDataFromUrl2(_ urlString: String, _ callBack: String) {
        let semaphore = DispatchSemaphore(value: 0)
        let request = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
        var html: String? = nil
        
        // request.timeoutInterval = 20.0 //(number as! NSTimeInterval)
        // request.httpMethod = "GET"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("gzip", forHTTPHeaderField: "Accept-encoding")
        
        let configuration =
            URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration,
                                 delegate: self,
                                 delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else {                                   // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            let cfEnc = CFStringEncodings.GB_18030_2000
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
            html = String(data: data, encoding: String.Encoding(rawValue: enc))!
            semaphore.signal()
            //print("responseString = \(responseString)")
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        let function = jsContext?.objectForKeyedSubscript(callBack)
        _ = function?.call(withArguments: [html ?? "", urlString])
    }

    internal func getDataFromUrl(_ urlString: String, _ callBack: String){
        //print("get url from: \(urlString)")
        let url:URL = URL(string: urlString)!
        var html: String? = nil
        let semaphore = DispatchSemaphore(value: 0)
        var request:URLRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //request.addValue("textml,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", forHTTPHeaderField: "Accept")
        //request.addValue("gzip, deflate, sdch", forHTTPHeaderField: "Accept-Encoding")
        //request.addValue("en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4,zh-TW;q=0.2,ko;q=0.2", forHTTPHeaderField: "Accept-Language")
        //request.addValue("max-age=0", forHTTPHeaderField: "Cache-Control")
        //request.addValue("keep-alive", forHTTPHeaderField: "Connection")
        request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36", forHTTPHeaderField: "User-Agent")
        let task = session.dataTask(with: request){
            (data, response, error) in
                let res = response as! HTTPURLResponse
            let enct:String = res.allHeaderFields["Content-Type"]! as! String
            //print(enct)
            if(enct.contains("GBK")){
                let cfEnc = CFStringEncodings.GB_18030_2000
                let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
                html = String(data: data!, encoding: String.Encoding(rawValue: enc))!
            }else if(enct.contains("UTF-8")){
                html = String(data: data!, encoding: String.Encoding.utf8)
            }
            else if(enct.contains("application/json")){
                html = String(data: data!, encoding: String.Encoding.utf8)
            }
            else{
                print("Unsolved encoding type: \(enct)")
            }
                semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: .distantFuture)
        let function = jsContext?.objectForKeyedSubscript(callBack)
        _ = function?.call(withArguments: [html ?? "", urlString])
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
        //let instanceOfCustomObject: CustomObject = CustomObject()
        //instanceOfCustomObject.readHttp();
        
        
        /*
         * Main web page
         *
         */
        let url:URL = URL(string: "http://m.taobao.com")!
        
        let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
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
        let url:URL = URL(string: "http://www.alimama.com")!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
    }
    @IBAction func taobaoButton(_ sender: UIButton) {
        let url:URL = URL(string: "http://m.taobao.com")!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    @IBAction func reDoButton(_ sender: UIButton) {
        webViewDidFinishLoad(webView)
    }
    @IBAction func shareUrl(_ sender: UIButton) {
        UIPasteboard.general.string = webView.request?.url?.absoluteString
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
        if(webView.request?.url?.absoluteString.contains("pub.alimama.com"))!{
            webView.stringByEvaluatingJavaScript(from: "var element = document.createElement('meta');  element.name = \"viewport\";  element.content = \"width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=3,user-scalable=1\"; var head = document.getElementsByTagName('head')[0]; head.appendChild(element);")
        }
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
        //print(request.url?.scheme ?? "Error request url");
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

