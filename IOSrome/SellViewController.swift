//
//  SellViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/4.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit
import JavaScriptCore

class SellViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /*
         * Main web page
         *
         */
        //let serverUrlString = AppStatus.sharedInstance.server.address + AppStatus.sharedInstance.server.port + AppStatus.sharedInstance.path.recommend
        //let serverUrlString = AppStatus.sharedInstance.contentServer.highBrokerPageURL
        //let url:URL = URL(string: serverUrlString)!
        
        //let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        //webView.loadRequest(request)
        webView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        if let path = Bundle.main.path(forResource: "shop", ofType: "html") {
            webView.loadRequest( URLRequest(url: URL(fileURLWithPath: path)) )
        }
    }
    
    var id:String = ""
    func showDetail(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "detail"))! as! ShopDetailViewController
        vc.goodID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showGuide(){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "guide"))! as! ShopTutorialViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("SelfViewController webView")
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            let url:String = (request.url?.absoluteString)!
            print("shop: load \(url)")
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let urlString:String = (request.url?.absoluteString)!
            let paraString = urlString[startIndex...]
            print(paraString)
            let method:String = String(describing: paraString)
            print("method is \(method)")
            let parameters:[String] = method.components(separatedBy: ":")
            print(parameters[0])
            id = parameters[1]
            switch parameters[0]{
            case "showDetail":
                print(parameters[0])
                showDetail()
                break
            default:
                print("Error parameter")
            }
            return false
        }else if(request.url?.absoluteString.hasPrefix("lanalert"))!{
            let url:String = (request.url?.absoluteString)!
            let range = url.range(of: ":")
            let startIndex = url.index(after: (range?.lowerBound)!)
            let method:String = String(describing: request.url?.absoluteString[startIndex...])
            let alert = UIAlertController (title: "提示", message: method.removingPercentEncoding
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }else if(request.url?.absoluteString.hasPrefix("load"))!{
            let function = jsContext?.objectForKeyedSubscript("doWork")
            _ = function?.call(withArguments: [AppStatus.sharedInstance.isVip])
        }

        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//         Dispose of any resources that can be recreated.
    }
    
    var jsContext: JSContext?
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("SelfViewController webViewDidFinishLoad")
        jsContext = (webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext)
        let model = SwiftJavaScriptModel()
        model.controller = self
        jsContext?.setObject(model, forKeyedSubscript: "LanJsBridge" as (NSCopying & NSObjectProtocol)?)
        model.jsContext = jsContext
        jsContext?.exceptionHandler = {
            (context, exception) in
            print("exception: ", exception ?? "No")
        }
        let function = jsContext?.objectForKeyedSubscript("doWork")
        _ = function?.call(withArguments: [AppStatus.sharedInstance.isVip])
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
