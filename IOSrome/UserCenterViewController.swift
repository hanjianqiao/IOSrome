//
//  UserCenterViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/8.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class UserCenterViewController: UIViewController {
    
    @IBOutlet weak var userIconButton: UIButton!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    func updateUserView(){
        if(AppStatus.sharedInstance.isLoggedIn == false){
            logoutButton.isHidden = true
            userNameButton.setTitle("点击登陆会淘账号", for: UIControlState.normal)
            userIconButton.setImage(UIImage(named: "tiny_user_head.png"), for: UIControlState.normal)
        }else{
            logoutButton.isHidden = false
            userNameButton.setTitle("你的用户名", for: UIControlState.normal)
            userIconButton.setImage(UIImage(named: "tiny0.png"), for: UIControlState.normal)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        updateUserView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userButton(_ sender: UIButton) {
        if(AppStatus.sharedInstance.isLoggedIn == false){
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "login"))! as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
        }
    }
    
    @IBAction func logout(_ sender: UIButton) {
        AppStatus.sharedInstance.logout()
        updateUserView()
    }
    
    func notLoggedInMessage(){
        let alert = UIAlertController (title: "未登录", message: "请登陆查看详细内容"
            , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func vipButton(_ sender: UIButton) {
        if(AppStatus.sharedInstance.isLoggedIn == false){
            notLoggedInMessage()
            return
        }
        
        if(AppStatus.sharedInstance.isVip){
            let date = Date()
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
            if(comp.year! <= AppStatus.sharedInstance.vipInfo.endYear
                && comp.month! <= AppStatus.sharedInstance.vipInfo.endMonth
                && comp.day! <= AppStatus.sharedInstance.vipInfo.endDay){
                //OK
            }else{
                AppStatus.sharedInstance.isVip = false
            }
        }

        var targetViewIdentifier:String
        if(AppStatus.sharedInstance.isVip == true){
            targetViewIdentifier = "vip"
        }else{
            targetViewIdentifier = "BuyVip"
        }
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: targetViewIdentifier))! as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func invitationButton(_ sender: UIButton) {
        if(AppStatus.sharedInstance.isLoggedIn == false){
            notLoggedInMessage()
            return
        }
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "invitation"))! as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func userGuideButton(_ sender: UIButton) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tutorial"))! as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func systemMessageButton(_ sender: UIButton) {
        if(AppStatus.sharedInstance.isLoggedIn == false){
            notLoggedInMessage()
            return
        }
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "message"))! as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func aboutUsButton(_ sender: UIButton) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "aboutus"))! as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
