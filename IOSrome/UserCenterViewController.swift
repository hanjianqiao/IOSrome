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

    @IBOutlet weak var unReadNoti: UILabel!
    
    @objc func updateDisplay(notification: NSNotification){
        OperationQueue.main.addOperation {
            //do stuff
            if(AppStatus.sharedInstance.isLoggedIn == false){
                self.logoutButton.isHidden = true
                self.userNameButton.setTitle("点击登陆会淘账号", for: UIControlState.normal)
                self.userIconButton.setImage(UIImage(named: "unlogged.png"), for: UIControlState.normal)
            }else{
                self.logoutButton.isHidden = false
                self.userNameButton.setTitle(AppStatus.sharedInstance.userInfo.userId, for: UIControlState.normal)
                self.userIconButton.setImage(UIImage(named: "Mine_head.png"), for: UIControlState.normal)
            }
            if(notification.userInfo != nil){
                let str = notification.userInfo?[AnyHashable("isThere")] as! Bool
                print(str)
                
                if(str == false){
                    self.unReadNoti.text = ""
                }else{
                    self.unReadNoti.text = "（新消息）"
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.updateDisplay),
            name: NSNotification.Name(rawValue: "update"),
            object: nil)
        NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: ["isThere":false])
        
        // do something in the background
        let request = URLRequest(url: URL(string: AppStatus.sharedInstance.contentServer.versionCheckURL)!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {               // check for fundamental networking error
                print("error=\(error)")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            
            if(responseString == nil){
                return
            }
            let json = JsonTools.convertToDictionary(text: responseString!)
            if(json == nil){
                return
            }
            
            let newVersion:Int = Int(json?["message"] as! String)!
            
            print("Current version is \(AppStatus.sharedInstance.version) and new version is \(newVersion)")
            if( newVersion > AppStatus.sharedInstance.version){
                print(json?["message"] ?? "")
                let alert = UIAlertController (title: "更新提示：为了更好的使用体验，请重新下载安装最新版本，下载地址请关注“小牛快淘”微信公众号，回复“最新版本”即可。", message: ""
                    , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        task.resume()
        
        let defaults = UserDefaults.standard
        let shouldLogin = defaults.string(forKey: defaultsKeys.savedLogin)
        print(shouldLogin ?? "nil")
        if(shouldLogin != nil && shouldLogin == "yes"){
            let queue = OperationQueue()
            queue.addOperation() {
                // do something in the background
                var request = URLRequest(url: URL(string: AppStatus.sharedInstance.userServer.login_url)!)
                request.httpMethod = "POST"
                let uuid = UUID().uuidString
                let postString = "{\"user_id\":\"" +
                    defaults.string(forKey: defaultsKeys.username)! + "\",\"password\":\"" +
                    defaults.string(forKey: defaultsKeys.passwd)! + "\",\"uuid\":\"" +
                    uuid + "\"}"
                request.httpBody = postString.data(using: .utf8)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                let task2 = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {               // check for fundamental networking error
                        print("error=\(error)")
                        return
                    }
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                        return
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    
                    if(responseString == nil){
                        return
                    }
                    let json = JsonTools.convertToDictionary(text: responseString!)
                    
                    if(json == nil){
                        return
                    }
                    if(json?["status"] as! String == "ok"){
                        let infodata = json?["data"] as! [String:AnyObject]
                        AppStatus.sharedInstance.userInfo.userId = infodata["user_id"] as! String
                        AppStatus.sharedInstance.userInfo.password = defaults.string(forKey: defaultsKeys.passwd)!
                        AppStatus.sharedInstance.userInfo.inviter = infodata["inviter"] as! String
                        AppStatus.sharedInstance.userInfo.invitation = infodata["code"] as! String
                        AppStatus.sharedInstance.vipInfo.endYear = Int(infodata["expire_year"] as! String)!
                        AppStatus.sharedInstance.vipInfo.endMonth = Int(infodata["expire_month"] as! String)!
                        AppStatus.sharedInstance.vipInfo.endDay = Int(infodata["expire_day"] as! String)!
                        AppStatus.sharedInstance.userInfo.level = infodata["level"] as! String
                        AppStatus.sharedInstance.userInfo.balance = infodata["balance"] as! String
                        AppStatus.sharedInstance.isLoggedIn = true
                        let date = Date()
                        let calendar = Calendar.current
                        let comp = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
                        let A = comp.year! > AppStatus.sharedInstance.vipInfo.endYear
                        let AE = comp.year! == AppStatus.sharedInstance.vipInfo.endYear
                        let B = comp.month! > AppStatus.sharedInstance.vipInfo.endMonth
                        let BE = comp.month! == AppStatus.sharedInstance.vipInfo.endMonth
                        let C = comp.day! > AppStatus.sharedInstance.vipInfo.endDay
                        if((A) || (AE && B) || (AE && BE && C)){
                            AppStatus.sharedInstance.isVip = false
                        }else{
                            AppStatus.sharedInstance.isVip = true
                        }
                        self.tabBarController?.tabBar.items?[0].isEnabled = true
                        self.tabBarController?.tabBar.items?[1].isEnabled = true
                        self.tabBarController?.tabBar.items?[2].isEnabled = true
                        self.tabBarController?.tabBar.items?[3].isEnabled = true
                        
                        NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: nil)
                        
                    }
                }
                task2.resume()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getQueryStrByDic(dic:[(String,String)])->String{
        var pars = ""
        for (index, element) in dic.enumerated() {
            if(index == 0){
                pars += "\(element.0)=\(element.1)";
            }else{
                pars += "&\(element.0)=\(element.1)";
            }
        }
        return pars;
    }
    
    func getSign(dic:Dictionary<String,String>,key:String) -> String{
        var sign:String = ""
        let dicNew = dic.sorted { (a, b) -> Bool in
            return a.0 < b.0
        }
        
        sign = getQueryStrByDic(dic: dicNew)
        sign += "&key=\(key)"
        print(sign)
        sign = (sign.MD5?.uppercased())!
        print(sign)
        return sign
    }

    @IBAction func userButton(_ sender: UIButton) {
        if(AppStatus.sharedInstance.isLoggedIn == false){
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "login"))! as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "money"))! as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func logout(_ sender: UIButton) {
        AppStatus.sharedInstance.logout()
        NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: ["isThere":false])
        self.tabBarController?.tabBar.items?[0].isEnabled = false
        self.tabBarController?.tabBar.items?[1].isEnabled = false
        self.tabBarController?.tabBar.items?[2].isEnabled = false
        self.tabBarController?.tabBar.items?[3].isEnabled = true
        self.tabBarController?.selectedIndex = 3
        let defaults = UserDefaults.standard
        defaults.setValue("no", forKey: defaultsKeys.savedLogin)
    }
    
    func notLoggedInMessage(){
        let alert = UIAlertController (title: "未登录", message: "请登陆查看详细内容"
            , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func notVipMessage(){
        let alert = UIAlertController (title: "提示", message: "开通会员后即可查看"
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
            let A = comp.year! > AppStatus.sharedInstance.vipInfo.endYear
            let AE = comp.year! == AppStatus.sharedInstance.vipInfo.endYear
            let B = comp.month! > AppStatus.sharedInstance.vipInfo.endMonth
            let BE = comp.month! == AppStatus.sharedInstance.vipInfo.endMonth
            let C = comp.day! > AppStatus.sharedInstance.vipInfo.endDay
            if((A) || (AE && B) || (AE && BE && C)){
                AppStatus.sharedInstance.isVip = false
            }else{
                AppStatus.sharedInstance.isVip = true
            }
        }

        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "vip"))! as UIViewController
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
        if(AppStatus.sharedInstance.isLoggedIn == false){
            notLoggedInMessage()
            return
        }
        if(AppStatus.sharedInstance.isVip == false){
            notVipMessage()
            return
        }
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tutorial"))! as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func systemMessageButton(_ sender: UIButton) {
        if(AppStatus.sharedInstance.isLoggedIn == false){
            notLoggedInMessage()
            return
        }
        NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: ["isThere":false])
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
