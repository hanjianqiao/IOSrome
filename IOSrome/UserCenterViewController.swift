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
    @IBOutlet weak var balancePanel: UIView!
    @IBOutlet weak var balance: UILabel!
    func updateUserView(){
        if(AppStatus.sharedInstance.isLoggedIn == false){
            logoutButton.isHidden = true
            balancePanel.isHidden = true
            userNameButton.setTitle("点击登陆会淘账号", for: UIControlState.normal)
            userIconButton.setImage(UIImage(named: "tiny_user_head.png"), for: UIControlState.normal)
            balance.text = "0.00"
        }else{
            logoutButton.isHidden = false
            balancePanel.isHidden = false
            userNameButton.setTitle(AppStatus.sharedInstance.userInfo.userId, for: UIControlState.normal)
            userIconButton.setImage(UIImage(named: "tiny0.png"), for: UIControlState.normal)
            balance.text = AppStatus.sharedInstance.userInfo.balance
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

    @IBAction func drawback(_ sender: UIButton) {
    }
    let serverUrlString = AppStatus.sharedInstance.userServer.charge_url
    @IBAction func charge(_ sender: UIButton) {
        print("Buy vip...")
        let payRequest = PayReq()
        payRequest.partnerId = "10000100"
        payRequest.prepayId = "1101000000140415649af9fc314aa427"
        payRequest.package = "Sign=WXPay"
        payRequest.nonceStr = "a462b76e7436e98e0ed6e13c64b4fd1c"
        payRequest.timeStamp = UInt32(NSDate(timeIntervalSinceNow: 0).timeIntervalSince1970)
        
        var dic:[String:String] = [:]
        dic["appid"] = AppStatus.sharedInstance.wechatAPPID
        dic["prepayid"] = payRequest.prepayId
        dic["package"] = payRequest.package
        dic["noncestr"] = payRequest.nonceStr
        dic["timestamp"] = "\(payRequest.timeStamp)"
        
        let sign = self.getSign(dic: dic, key: AppStatus.sharedInstance.wechatPayKey)
        
        payRequest.sign = sign
        
        WXApi.send(payRequest)
        
        let queue = OperationQueue()
        
        // do something immediately
        let alertLogging = UIAlertController (title: "充值中", message: "请稍后。。。"
            , preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertLogging, animated: true, completion: nil)
        
        queue.addOperation() {
            // do something in the background
            var request = URLRequest(url: URL(string: self.serverUrlString)!)
            request.httpMethod = "POST"
            let postString = "{\"user_id\":\"" +
                AppStatus.sharedInstance.userInfo.userId + "\",\"password\":\"" +
                AppStatus.sharedInstance.userInfo.password + "\"}"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                
                guard let data = data, error == nil else {               // check for fundamental networking error
                    print("error=\(error)")
                    alertLogging.dismiss(animated: true, completion:{
                        OperationQueue.main.addOperation {
                            alertLogging.dismiss(animated: true, completion: nil)
                            let alert = UIAlertController (title: "网络异常", message: "请重新充值"
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
                }
                //print(data)
                let responseString = String(data: data, encoding: .utf8)!
                print("responseString = \(responseString)")
                
                let json = JsonTools.convertToDictionary(text: responseString)!
                
                print(json["status"] as! String == "failed")
                print(json["message"]!)
                
                alertLogging.dismiss(animated: true, completion:{
                    OperationQueue.main.addOperation {
                        alertLogging.dismiss(animated: true, completion: nil)
                        let alert = UIAlertController (title: "充值结果", message: json["message"] as? String
                            , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
            task.resume()
        }
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
