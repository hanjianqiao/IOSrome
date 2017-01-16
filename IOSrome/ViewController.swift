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

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.loadPage),
            name: NSNotification.Name(rawValue: "noti_load_page"),
            object: nil)
        
        let url:URL = URL(string: AppStatus.sharedInstance.contentServer.mainPageURL)!
        
        let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        webView.delegate = self
        webView.loadRequest(request)
    }
    
    /**
     ** Buttons
     **
     **/
    @IBAction func homeButton(_ sender: UIButton) {
        let url:URL = URL(string: "http://www.alimama.com")!
        var request:URLRequest = URLRequest(url: url)
        request.addValue("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36", forHTTPHeaderField: "User-Agent")
        webView.loadRequest(request)
    }
    @IBAction func taobaoButton(_ sender: UIButton) {
        let url:URL = URL(string: AppStatus.sharedInstance.contentServer.mainPageURL)!
        let request:URLRequest = URLRequest(url: url)
        webView.loadRequest(request)
    }

    @IBAction func shareUrl(_ sender: UIButton) {
        UIPasteboard.general.string = webView.request?.url?.absoluteString
    }

    @IBAction func huitaoyixia(_ sender: UIButton) {
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
        print(webView.request?.url?.absoluteString ?? "No url")
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
            print("reloading...\(str)")
            let url:URL = URL(string: str)!
            let request:URLRequest = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
    /**
     **
     ** Called when finish loading a page
     **
     **
     **/
    func webViewDidFinishLoad(_ webView: UIWebView) {
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
}

