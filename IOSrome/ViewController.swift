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
        let url:URL = URL(string: "http://www.alimama.com")!
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
            let C = comp.day! > AppStatus.sharedInstance.vipInfo.endDay
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
        //print("Webview fail with error \(error)");
        var str = String(describing: error)
        str = str.substring(from: (str.range(of: "NSErrorFailingURLStringKey=")?.upperBound)!)
        str = str.substring(to: (str.range(of: ",")?.lowerBound)!)
        let when = DispatchTime.now() + 1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            if(self.needReload){
                print("reloading...\(str)")
                let url:URL = URL(string: str)!
                let request:URLRequest = URLRequest(url: url)
                self.needReload = false
                webView.loadRequest(request)
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
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("webview is : \(String(describing: webView.request?.url?.absoluteString)) Will loading \(String(describing: request.url?.absoluteString))")
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let method:String = (request.url?.absoluteString.substring(from: startIndex))!
            let targetStr = method.substring(from:(method.range(of: "?q=")?.upperBound)!)
            if((targetStr.removingPercentEncoding?.lowercased().hasPrefix("http://"))! || (targetStr.removingPercentEncoding?.lowercased().hasPrefix("https://"))!){
                self.webView.loadRequest(URLRequest(url:URL(string:targetStr.removingPercentEncoding!)!))
            }else{
                self.webView.loadRequest(URLRequest(url:URL(string:"https://s.m.taobao.com/h5"+method)!))
            }
            return false
        }else if(webView.request?.url != nil && (webView.request?.url?.absoluteString.hasPrefix("http://c.b1wt.com"))!){
            if(request.url?.absoluteString.hasPrefix("taobao:"))!{
                let para:[String] = (request.url?.absoluteString.components(separatedBy: ":"))!
                let newUrl:String = "https:"+para[1];
                webView.loadRequest(URLRequest(url:URL(string:newUrl)!))
                return false;
            }
        }else if(webView.request?.url != nil && (webView.request?.url?.absoluteString.hasPrefix("http://c.b6wq.com"))!){
            if(request.url?.absoluteString.hasPrefix("taobao:"))!{
                let para:[String] = (request.url?.absoluteString.components(separatedBy: ":"))!
                let newUrl:String = "https:"+para[1];
                webView.loadRequest(URLRequest(url:URL(string:newUrl)!))
                return false;
            }
        }
        return true
        
    }
}

