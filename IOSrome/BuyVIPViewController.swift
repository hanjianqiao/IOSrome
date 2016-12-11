//
//  BuyVIPViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/11.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class BuyVIPViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyVIP(_ sender: UIButton) {
        AppStatus.sharedInstance.isVip = true
    }

    @IBAction func help(_ sender: UIButton) {
        let alert = UIAlertController (title: "帮助", message: "关注XX微信公众号，在线提问，7*24小时为您解答"
            , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
