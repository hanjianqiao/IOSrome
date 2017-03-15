//
//  TutorialViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/1/4.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        /*
         * Main web page
         *
         */
        //let serverUrlString = AppStatus.sharedInstance.server.address + AppStatus.sharedInstance.server.port + AppStatus.sharedInstance.path.selfchoose
        //let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        //webView.loadRequest(request)
        webView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        if let path = Bundle.main.path(forResource: "newcomer", ofType: "html") {
            webView.loadRequest( URLRequest(url: URL(fileURLWithPath: path)) )
        }
    }
    
    func loadPage(address:String){
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "generalwebview"))! as! GeneralWebViewController
        vc.targetAddress = address
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        if(request.url?.absoluteString.hasPrefix("http://rule.alimama.com/"))!{
//            loadPage(address: (request.url?.absoluteString)!)
//            return false
//        }
        print(request.url?.absoluteString)
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
