//
//  WebPageViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/5/9.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit

class WebPageViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var target:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.scalesPageToFit = true
        webView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        if(target.hasPrefix("http")){
            webView.loadRequest( URLRequest(url: URL(string: target)!) )
        }else if(target.hasPrefix("file")){
            let parameters:[String] = target.components(separatedBy: ":")
            if let path = Bundle.main.path(forResource: parameters[1], ofType: parameters[2]) {
                webView.loadRequest( URLRequest(url: URL(fileURLWithPath: path)) )
            }
        }else{
            webView.loadRequest( URLRequest(url: URL(string: target)!))
        }
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
