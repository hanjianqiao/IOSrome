//
//  UserCenterViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/8.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController {
    
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        scroll.backgroundColor = UIColor.gray
        scroll.contentSize = scroll.bounds.size
        
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
