//
//  VIPDetailViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/14.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class VIPDetailViewController: UIViewController {

    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var inviteCode: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var dateString = String(AppStatus.sharedInstance.vipInfo.endYear) + "年-"
        dateString += String(AppStatus.sharedInstance.vipInfo.endMonth) + "月-"
        dateString += String(AppStatus.sharedInstance.vipInfo.endDay) + "日"
        expireDate.text = dateString
        inviteCode.text = AppStatus.sharedInstance.userInfo.inviteCode
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
