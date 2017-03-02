//
//  LoginViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/6.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    let serverUrlString = AppStatus.sharedInstance.userServer.login_url
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        password.isSecureTextEntry = true
        
        username.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: username.intrinsicContentSize.height+10, height: username.intrinsicContentSize.height+10))
        let image = UIImage(named: "手机号.png")
        imageView.image = image
        imageView.contentMode = UIViewContentMode.center
        username.leftView = imageView
        username.frame.size.height = 40
        
        password.leftViewMode = UITextFieldViewMode.always
        let imageViewP = UIImageView(frame: CGRect(x: 0, y: 0, width: username.intrinsicContentSize.height+10, height: username.intrinsicContentSize.height+10))
        let imageP = UIImage(named: "密码.png")
        imageViewP.contentMode = UIViewContentMode.center
        imageViewP.image = imageP
        password.leftViewMode = UITextFieldViewMode.always
        password.leftView = imageViewP
        password.frame.size.height = 40
        
        
        let defaults = UserDefaults.standard
        username.text = defaults.string(forKey: defaultsKeys.username)
        password.text = defaults.string(forKey: defaultsKeys.passwd)
        if( defaults.string(forKey: defaultsKeys.username) == nil
            || defaults.string(forKey: defaultsKeys.passwd) == nil
            || defaults.string(forKey: defaultsKeys.username) == ""
            || defaults.string(forKey: defaultsKeys.passwd) == ""){
            self.savePasswd.isOn = false
        }else{
            self.savePasswd.isOn = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        /*
        let client = TCPClient(address: "www.apple.com", port: 80)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "GET / HTTP/1.0\n\n" ) {
            case .success:
                guard let data = client.read(1024*10) else { return }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    print(response)
                }
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        */
        let alert = UIAlertController (title: "帮助", message: "如有疑问请关注“小牛快淘”微信公众号", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBOutlet weak var savePasswd: UISwitch!
    
    @IBAction func doSave(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        if(savePasswd.isOn){
            defaults.setValue(username.text!, forKey: defaultsKeys.username)
            defaults.setValue(password.text!, forKey: defaultsKeys.passwd)
        }else{
            defaults.setValue(nil, forKey: defaultsKeys.username)
            defaults.setValue(nil, forKey: defaultsKeys.passwd)
        }
    }
    @IBAction func doLogin(_ sender: UIButton) {
        let queue = OperationQueue()
        let defaults = UserDefaults.standard
        if(savePasswd.isOn){
            defaults.setValue(username.text!, forKey: defaultsKeys.username)
            defaults.setValue(password.text!, forKey: defaultsKeys.passwd)
        }else{
            defaults.setValue(nil, forKey: defaultsKeys.username)
            defaults.setValue(nil, forKey: defaultsKeys.passwd)
        }
        // do something immediately
        let alertLogging = UIAlertController (title: "正在登录...", message: ""
            , preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertLogging, animated: true, completion: nil)
        
        queue.addOperation() {
            // do something in the background
            var request = URLRequest(url: URL(string: self.serverUrlString)!)
            request.httpMethod = "POST"
            let uuid = UUID().uuidString
            let postString = "{\"user_id\":\"" +
                self.username.text! + "\",\"password\":\"" +
                self.password.text! + "\",\"uuid\":\"" +
                uuid + "\"}"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {               // check for fundamental networking error
                    print("error=\(error)")
                    alertLogging.dismiss(animated: true, completion:{
                        OperationQueue.main.addOperation {
                            let alert = UIAlertController (title: "网络异常", message: "请重新登录"
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    alertLogging.dismiss(animated: true, completion:{
                        OperationQueue.main.addOperation {
                            let alert = UIAlertController (title: "服务器异常", message: "请重新登录"
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    return
                }

                let responseString = String(data: data, encoding: .utf8)!
                print("responseString = \(responseString)")
                
                let json = JsonTools.convertToDictionary(text: responseString)
                
                if(json == nil){
                    alertLogging.dismiss(animated: true, completion:{
                        OperationQueue.main.addOperation {
                            let alert = UIAlertController (title: "服务器返回异常", message: "请重新尝试"
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    return
                }
                
                print(json?["status"] as! String == "failed")
                print(json?["message"]! ?? "")
                
                OperationQueue.main.addOperation {
                    alertLogging.dismiss(animated: true, completion:{
                        if(json?["status"] as! String == "ok"){
                            let infodata = json?["data"] as! [String:AnyObject]
                            AppStatus.sharedInstance.userInfo.userId = infodata["user_id"] as! String
                            AppStatus.sharedInstance.userInfo.password = self.password.text!
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
                            _ = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2] as! UserCenterViewController
                            NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: nil)
                            _ = self.navigationController?.popViewController(animated: true)
                        }else{
                            alertLogging.dismiss(animated: true, completion: nil)
                            let alert = UIAlertController (title: "登陆结果", message: json?["message"] as? String
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
            task.resume()

            OperationQueue.main.addOperation() {
                // when done, update your UI and/or model on the main queue
            }
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
