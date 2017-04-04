//
//  MainTabBarController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/11.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.items?[0].isEnabled = false
        self.tabBar.items?[1].isEnabled = false
        self.tabBar.items?[2].isEnabled = false
        self.tabBar.items?[3].isEnabled = true
        self.tabBar.items?[0].tag = 0
        self.tabBar.items?[1].tag = 1
        self.tabBar.items?[2].tag = 2
        self.tabBar.items?[3].tag = 3
        self.selectedIndex = 3
        self.delegate = self
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
    

    func tabBarController(_ tabBarController: UITabBarController,
                                   shouldSelect viewController: UIViewController) -> Bool{
        print("gonna select tag:\(viewController.tabBarItem.tag)")
        switch(viewController.tabBarItem.tag){
        case 0:
            if(AppStatus.sharedInstance.isVip == false){
                OperationQueue.main.addOperation {
                    let alert = UIAlertController (title: "你不是VIP,无法使用查询功能", message: ""
                        , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return false
            }
            break
        case 1:
            if(AppStatus.sharedInstance.isVip == false){
                OperationQueue.main.addOperation {
                    let alert = UIAlertController (title: "您不是VIP，无法使用推荐商城", message: ""
                        , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return false
            }
            break
        case 2:
            if(AppStatus.sharedInstance.isVip == false){
                OperationQueue.main.addOperation {
                    let alert = UIAlertController (title: "您不是VIP，无法使用自选商城", message: ""
                        , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return false
            }
            if(AppStatus.sharedInstance.upisVip == false){
                OperationQueue.main.addOperation {
                    let alert = UIAlertController (title: "您的上级："+AppStatus.sharedInstance.parentInfo.username+"不是VIP，无法使用自选商城", message: ""
                        , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return false
            }
            break
        default:
            break
        }
        return true
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
