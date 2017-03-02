//
//  TaoTutorialViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/3/3.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit

class TaoTutorialViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.scalesPageToFit = true
        webView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        if let path = Bundle.main.path(forResource: "newcomer", ofType: "html") {
            webView.loadRequest( URLRequest(url: URL(fileURLWithPath: path)) )
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
