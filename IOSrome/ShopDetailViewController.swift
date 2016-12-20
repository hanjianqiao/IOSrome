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
        let serverUrlString = "http://kouchenvip.com/tao/h5/item.html?id=" + goodID
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}