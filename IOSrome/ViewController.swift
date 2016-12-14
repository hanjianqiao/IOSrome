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
    
        let url:URL = URL(string: "http://m.taobao.com")!
        
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
        let url:URL = URL(string: "http://m.taobao.com")!
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
            if(comp.year! <= AppStatus.sharedInstance.vipInfo.endYear
                && comp.month! <= AppStatus.sharedInstance.vipInfo.endMonth
                && comp.day! <= AppStatus.sharedInstance.vipInfo.endDay){
                //OK
            }else{
                AppStatus.sharedInstance.isVip = false
            }
        }
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "huitaoyixia"))! as! HuitaoViewController
        let strUrl:String = (webView.request?.url?.absoluteString)!
        vc.targetUrl = strUrl
        self.navigationController?.pushViewController(vc, animated: true)
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

