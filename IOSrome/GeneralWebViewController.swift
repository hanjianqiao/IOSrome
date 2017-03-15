//
//  GeneralWebViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/3/12.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit

class GeneralWebViewController: UIViewController , UIWebViewDelegate{
    
    var targetAddress:String = ""

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url:URL = URL(string: targetAddress)!
        let request:URLRequest = URLRequest(url: url)
        webView.scalesPageToFit = true
        webView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        webView.loadRequest(request)
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
