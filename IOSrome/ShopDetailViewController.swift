//
//  ShopDetailViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/20.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class ShopDetailViewController: UIViewController, UIWebViewDelegate {
    
    var goodID:String = ""

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let serverUrlString = AppStatus.sharedInstance.contentServer.detailShopPageURL + "?id=" + goodID
        let url:URL = URL(string: serverUrlString)!
        
        let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var taoDetail:String = ""
    func showTaobaoDetail(){
        NotificationCenter.default.post(name: Notification.Name("noti_load_page"), object: self, userInfo: ["url":taoDetail])
    }
    var targetUrl:String = ""
    func showHuitao(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "huitaoyixia"))! as! huitaoShopViewController
        vc.url = targetUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let method:String = (request.url?.absoluteString.substring(from: startIndex))!
            let parameters:[String] = method.components(separatedBy: ":")
            let selector:Selector = NSSelectorFromString(parameters[0])
            taoDetail = parameters[1]+":"+parameters[2]
            if self.responds(to: selector){
                let control: UIControl = UIControl()
                control.sendAction(selector, to: self, for: nil)
            }
            NSLog("IOS call")
            return false
        } else if (request.url?.absoluteString.hasPrefix("clipboard"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let dataStr:String = (request.url?.absoluteString.substring(from: startIndex))!
            UIPasteboard.general.string = dataStr;
            return false
        } else if (request.url?.absoluteString.hasPrefix("huitao"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let dataStr:String = (request.url?.absoluteString.substring(from: startIndex))!
            targetUrl = dataStr;
            showHuitao()
            return false
        }
        return true
        
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
