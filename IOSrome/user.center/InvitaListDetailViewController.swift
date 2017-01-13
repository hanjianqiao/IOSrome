//
//  InvitaListDetailViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/1/4.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit

class InvitaListDetailViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*
         * Main web page
         *
         */
        //let serverUrlString = AppStatus.sharedInstance.server.address + AppStatus.sharedInstance.server.port + AppStatus.sharedInstance.path.selfchoose
        let serverUrlString = AppStatus.sharedInstance.contentServer.agentPageURL4
        let url:URL = URL(string: serverUrlString)!
        
        let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        webView.delegate = self
    }
    
    var id:String = ""
    func showDetail(){
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.url?.absoluteString.hasPrefix("ios"))!{
            NSLog("IOS call")
            return false
        }
        print(request.url ?? "Error request url");
        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
