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
    
    var jsString: String?
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do{
            let filePath = Bundle.main.path(forResource: "autofill", ofType: "js")
            try jsString = String(contentsOfFile: filePath!)
        }catch let err as NSError{
            print(err)
        }

        webView.scalesPageToFit = true
        webView.delegate = self
        webView.isOpaque = false
        webView.backgroundColor = UIColor.white
        webView.loadRequest( URLRequest(url: URL(string: "http://alimama.com/")!) )
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //print(webView.request?.url?.absoluteString)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var jsContext: JSContext?
    @IBAction func fill(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let alimama_username = defaults.string(forKey: defaultsKeys.alimama_username)
        if(alimama_username != nil){
            UIPasteboard.general.string = alimama_username!;
        }else{
            UIPasteboard.general.string = ""
        }
    }

    @IBAction func copyPassword(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let alimama_password = defaults.string(forKey: defaultsKeys.alimama_password)
        if(alimama_password != nil){
            UIPasteboard.general.string = alimama_password!;
        }else{
            UIPasteboard.general.string = ""
        }
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
