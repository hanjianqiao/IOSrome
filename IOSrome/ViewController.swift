//
//  ViewController.swift
//  IOSrome
//
//  Created by Lanchitour on 2016/11/18.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController, UIWebViewDelegate, UISearchBarDelegate  {

    @IBOutlet weak var bt_kuaitaoyixia: UIButton!
    @IBOutlet weak var webView: UIWebView!
    var needReload:Bool = false
    var mainUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.loadPage),
            name: NSNotification.Name(rawValue: "noti_load_page"),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.loadFile),
            name: NSNotification.Name(rawValue: "noti_load_file"),
            object: nil)
//        
//        let url:URL = URL(string: mainUrl)!
//        
//        let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        webView.delegate = self
        needReload = true
//        webView.loadRequest(request)
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        if let path = Bundle.main.path(forResource: "index", ofType: "html") {
            webView.loadRequest( URLRequest(url: URL(fileURLWithPath: path)) )
        }
    }
    
    /**
     ** Buttons
     **
     **/
    @IBAction func homeButton(_ sender: UIButton) {
        let url:URL = URL(string: AppStatus.sharedInstance.contentServer.alimamaUrl)!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
    }
    @IBAction func taobaoButton(_ sender: UIButton) {
        if let path = Bundle.main.path(forResource: "index", ofType: "html") {
            webView.loadRequest( URLRequest(url: URL(fileURLWithPath: path)) )
        }
    }

    @IBAction func goBack(_ sender: UIButton) {
        if(webView.canGoBack){
            webView.goBack()
        }
    }
    @IBAction func goForward(_ sender: UIButton) {
        if(webView.canGoForward){
            webView.goForward()
        }
        
    }
    @IBAction func shareUrl(_ sender: UIButton) {
        UIPasteboard.general.string = webView.request?.url?.absoluteString
    }

    @IBAction func kuaitao(_ sender: UIButton) {
        if(AppStatus.sharedInstance.isVip){
            let date = Date()
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
            let A = comp.year! > AppStatus.sharedInstance.vipInfo.endYear
            let AE = comp.year! == AppStatus.sharedInstance.vipInfo.endYear
            let B = comp.month! > AppStatus.sharedInstance.vipInfo.endMonth
            let BE = comp.month! == AppStatus.sharedInstance.vipInfo.endMonth
            let C = comp.day! >= AppStatus.sharedInstance.vipInfo.endDay
            if((A) || (AE && B) || (AE && BE && C)){
                AppStatus.sharedInstance.isVip = false
            }else{
                AppStatus.sharedInstance.isVip = true
            }
        }
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "huitaoyixia"))! as! HuitaoViewController
        let strUrl:String = (webView.request?.url?.absoluteString)!
        vc.targetUrl = strUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /**
     **
     ** Called when start to load a page
     **
     **/
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("Starting...\(String(describing: webView.request?.url?.absoluteString))")
    }
    
    /**
     **
     ** Called when failed to load a page
     **
     **/
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Webview fail with error \(error)");
        var str = String(describing: error)
        let index = str.index(after: (str.range(of: "NSErrorFailingURLStringKey=")?.upperBound)!)
        str = String(describing: str[index...])
        let index2 = str.index(after: (str.range(of: ",")?.lowerBound)!)
        str = String(describing: str[...index2])
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            if(self.needReload){
                print("reloading...\(str)")
                if let url:URL = URL(string: str){
                    let request:URLRequest = URLRequest(url: url)
                    self.needReload = false
                    webView.loadRequest(request)
                }
            }
        }
    }
    /**
     **
     ** Called when finish loading a page
     **
     **
     **/
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Finished...\(String(describing: webView.request?.url?.absoluteString))")
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
    @objc func loadPage(notification: NSNotification){
        //do stuff
        
        if((self.navigationController?.viewControllers.count)! > 1){
            _ = self.navigationController?.popViewController(animated: true)
        }
        let str = notification.userInfo?[AnyHashable("url")] as! String
        
        print(str)
        
        let url:URL = URL(string: str)!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
        
        self.tabBarController?.selectedIndex = 0;
    }
    @objc func loadFile(notification: NSNotification){
        //do stuff
        
        if((self.navigationController?.viewControllers.count)! > 1){
            _ = self.navigationController?.popViewController(animated: true)
        }
        let str = notification.userInfo?[AnyHashable("url")] as! String
        
        print("taobao notified to load file: \(str)")
        
        if let path = Bundle.main.path(forResource: str, ofType: "html") {
            webView.loadRequest( URLRequest(url: URL(fileURLWithPath: path)) )
        }
        
        self.tabBarController?.selectedIndex = 0;
    }
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("webview is : \(String(describing: webView.request?.url?.absoluteString)) Will loading \(String(describing: request.url?.absoluteString))")
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let method:String! = String(describing: (request.url?.absoluteString[startIndex...])!)
            let upbond:String.Index! = method.range(of: "?q")?.upperBound
            var targetStr: String!
            if (upbond < method.endIndex){
                let index = method.index(after: upbond!)
                targetStr = String(describing: method[index...])
            }else{
                targetStr = ""
            }
            //print(targetStr.removingPercentEncoding)
            let decodedTarget = targetStr.removingPercentEncoding!
            if((decodedTarget.hasPrefix("http://")) || (decodedTarget.hasPrefix("https://"))){
                let pre = matches(for: "http.+\\?", in: decodedTarget)
                let post = matches(for: "id=\\d+", in: decodedTarget)
                if(pre.count == 0 || post.count == 0){
                    let alert = UIAlertController (title: "不正确的商品地址", message: ""
                        , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return false
                }
                let newTarget = pre[0] + post[0]
                self.webView.loadRequest(URLRequest(url:URL(string:newTarget)!))
            }else{
                self.webView.loadRequest(URLRequest(url:URL(string:"https://s.m.taobao.com/h5"+method)!))
            }
            return false
        }else if(request.url?.absoluteString.hasPrefix("taobao:"))!{
            if(webView.request?.url != nil && (!(webView.request?.url?.absoluteString.hasPrefix("http://h5.m.taobao.com/awp/core/detail.htm?"))!)
                 && (!(webView.request?.url?.absoluteString.hasPrefix("https://item.taobao.com/item.htm?id="))!)){
                let para:[String] = (request.url?.absoluteString.components(separatedBy: ":"))!
                let newUrl:String = "https:"+para[1];
                webView.loadRequest(URLRequest(url:URL(string:newUrl)!))
            }
            return false;
        }
        return true
        
    }
}

