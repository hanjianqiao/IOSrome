//
//  SelfDetailViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/29.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

class SelfDetailViewController: UIViewController, UIWebViewDelegate {
    
    var goodID:String = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make navigation bar full transparent
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        // Do any additional setup after loading the view.
        webView.scalesPageToFit = true
        //webView.loadRequest(request)
        webView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        if let path = Bundle.main.path(forResource: "detail_self", ofType: "html") {
            webView.loadRequest( URLRequest(url: URL(fileURLWithPath: path)) )
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var taoDetail:String = ""
    func showTaobaoDetail(){
        //NotificationCenter.default.post(name: Notification.Name("noti_load_page"), object: self, userInfo: ["url":taoDetail])
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "taodetail"))! as! TaobaoDetailViewController2
        vc.address = taoDetail
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let method:String = String(describing: (request.url?.absoluteString[startIndex...])!)
            let parameters:[String] = method.components(separatedBy: ":")
            taoDetail = parameters[1]+":"+parameters[2]
            
            switch parameters[0]{
            case "showTaobaoDetail":
                showTaobaoDetail()
                break
            default:
                print("Error parameter")
            }
            NSLog("IOS call")
            return false
        } else if (request.url?.absoluteString.hasPrefix("clipboard"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let dataStr:String = String(describing: (request.url?.absoluteString[startIndex...])!).removingPercentEncoding!
            UIPasteboard.general.string = dataStr;
            let alert = UIAlertController (title: "已复制", message: UIPasteboard.general.string
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        } else if (request.url?.absoluteString.hasPrefix("alert"))!{
            let alert = UIAlertController (title: "没有淘口令", message: ""
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
        
    }
    
    var jsContext: JSContext?
    func webViewDidFinishLoad(_ webView: UIWebView) {
        jsContext = (webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext)
        let model = SwiftJavaScriptModel()
        model.controller = self
        jsContext?.setObject(model, forKeyedSubscript: "LanJsBridge" as (NSCopying & NSObjectProtocol)?)
        model.jsContext = jsContext
        jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception: ", exception ?? "No")
        }
        webView.stringByEvaluatingJavaScript(from: "doWork('?id="+goodID+"')")
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
