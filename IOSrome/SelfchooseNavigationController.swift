//
//  SelfchooseNavigationController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/16.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class SelfchooseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let UserViewController = UIStoryboard(name: "Selfchoose", bundle: nil).instantiateInitialViewController() as UIViewController!
        let vcArray = [UserViewController]
        self.viewControllers = vcArray as! [UIViewController]
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
