//
//  SwiftJavascriptBridge.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/14.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import Foundation

import JavaScriptCore

@objc protocol SwiftJavaScriptDelegate: JSExport{
    func test0() -> String
    func test1(_ para: String ) -> String
    func test2(_ para0:String,_ para1:String) -> String
    func have(_ a: String,_ b:String)->String
    func getDataFromUrlSynch(_ urlString: String, _ callBack: String)
    func getDataFromUrl(_ urlString: String, _ callBack: String)
    func setClipBoard(_ string: String)
    func isVIP() -> Bool
}
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate, URLSessionDelegate{
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
    internal func isVIP() -> Bool {
        if(AppStatus.sharedInstance.isVip){
            return true
        }else{
            return false
        }
    }
    
    internal func setClipBoard(_ string: String) {
        //print("set clipboart: \(string)")
        UIPasteboard.general.string = string;
    }
    
    internal func getDataFromUrlSynch(_ urlString: String, _ callBack: String){
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
    
    
    
    internal func getDataFromUrl(_ urlString: String, _ callBack: String){
        let url:URL = URL(string: urlString)!
        var html: String? = nil
        //let semaphore = DispatchSemaphore(value: 0)
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
        let task = session.dataTask(with: request, completionHandler:{
            (data: Data?, response: URLResponse?, error: Error?) in
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
            
            //print("get url from: \(urlString) -> \(html)")
            //print("get url from: \(urlString)")
            
            let function = self.jsContext?.objectForKeyedSubscript(callBack)
            _ = function?.call(withArguments: [html ?? "", urlString])
            //semaphore.signal()
        })
        task.resume()
        //_ = semaphore.wait(timeout: .distantFuture)
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
    
    
}
