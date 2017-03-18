//
//  MainTabBarController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/11.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.items?[0].isEnabled = false
        self.tabBar.items?[1].isEnabled = false
        self.tabBar.items?[2].isEnabled = false
        self.tabBar.items?[3].isEnabled = true
        self.tabBar.items?[0].tag = 0;
        self.tabBar.items?[1].tag = 1
        self.tabBar.items?[2].tag = 2
        self.tabBar.items?[3].tag = 3
        self.selectedIndex = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //This method will be called when user changes tab.
        print("current tag: \(self.selectedIndex), selected tag: \(item.tag)")
        
        if(self.selectedIndex == 0 && item.tag == 0){
            NotificationCenter.default.post(name: Notification.Name("noti_load_file"), object: self, userInfo: ["url":"index"])
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
