//
//  TaoTutorialViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/3/3.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

class TaobaoAlimama: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var target:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        webView.scalesPageToFit = true
        webView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        webView.loadRequest( URLRequest(url: URL(string: target)!) )
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //print(webView.request?.url?.absoluteString)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("Alilogin: reloading \(String(describing: request.url?.absoluteString))")
        if((request.url?.absoluteString.hasPrefix("https://login.m.taobao.com"))! || (request.url?.absoluteString.hasPrefix("https://login.taobao.com"))! ||  (request.url?.absoluteString.hasPrefix("https://www.alimama.com/"))! ||  (request.url?.absoluteString.hasPrefix("http://www.alimama.com/"))! ||  (request.url?.absoluteString.hasPrefix("https://ynuf.aliapp.org/la.htm"))! || (request.url?.absoluteString.hasPrefix("http://h5.m.taobao.com/mlapp/mytaobao.html"))! || (request.url?.absoluteString.hasPrefix("https://login.m.taobao.com"))!){
                    return true
        }else if((request.url?.absoluteString.hasPrefix("http://pub.alimama.com"))!){
            webView.loadRequest(URLRequest(url: URL(string:"http://www.alimama.com/")!))
            return false
        }
        return false
        
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
