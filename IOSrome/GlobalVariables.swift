//
//  GlobalVariables.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/9.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import Foundation

struct defaultsKeys {
    static let username = "UserName"
    static let passwd = "Password"
    static let savedLogin = "savedLogin"
    static let alimama_cookie = "alimamaCookie"
}

class AppStatus {
    class var sharedInstance: AppStatus {
        struct Static {
            static let instance = AppStatus()
        }
        return Static.instance
    }
    
    let wechatAPPID:String = "wxb4ba3c02aa476ea1"
    let wechatPayKey:String = "a462b76e7436e98e0ed6e13c64b4fd1c"
    
    var version:Int = 8
    
    var isLoggedIn:Bool
    var userID:String
    var grantToken:String
    var isVip:Bool
    var upisVip:Bool
    var regInfo:RegisterInfo
    var userServer:UserServer
    var contentServer:ContentServer
    var vipInfo:VipInfo
    var userInfo:UserInfo
    var parentInfo:ParentInfo
    
    init(){
        isLoggedIn = false
        userID = ""
        grantToken = ""
        isVip = false
        upisVip = false
        regInfo = RegisterInfo()
        userServer = UserServer()
        contentServer = ContentServer()
        vipInfo = VipInfo()
        userInfo = UserInfo()
        parentInfo = ParentInfo()
    }
    func logout(){
        isLoggedIn = false
        userID = ""
        grantToken = ""
        isVip = false
        regInfo.clean()
        vipInfo.clean()
        userInfo.clean()
        parentInfo.clean()
    }
    
    func periodCheck(){
        print("Period check...")
        if(AppStatus.sharedInstance.isLoggedIn == true){
            
            // do something in the background
            var request = URLRequest(url: URL(string: AppStatus.sharedInstance.userServer.newMessageCheck_url)!)
            request.httpMethod = "POST"
            let postString = "{\"user_id\":\"" +
                AppStatus.sharedInstance.userInfo.userId + "\",\"password\":\"" +
                AppStatus.sharedInstance.userInfo.password + "\"}"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {               // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                let responseString = String(data: data, encoding: .utf8)!
                print(responseString)
                let prej = JsonTools.convertToDictionary(text: responseString)
                if((prej) != nil){
                    let json = prej!
                    if(json["status"] as! String == "ok"){
                        let nowid = json["message"] as! String
                        if(nowid == "yes"){
                            NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: ["isThere":true])
                        }
                    }
                }
            }
            task.resume()
        }
        update()
        let when = DispatchTime.now() + 60 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.periodCheck()
        }
    }
    func update(){
        let queue = OperationQueue()
        queue.addOperation() {
            // do something in the background
            var request = URLRequest(url: URL(string: AppStatus.sharedInstance.userServer.login_url)!)
            request.httpMethod = "POST"
            let postString = "{\"user_id\":\"" +
                AppStatus.sharedInstance.userInfo.userId + "\",\"password\":\"" +
                AppStatus.sharedInstance.userInfo.password + "\"}"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {               // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                let responseString = String(data: data, encoding: .utf8)!
                let json = JsonTools.convertToDictionary(text: responseString)!
                if(json["status"] as! String == "ok"){
                    let infodata = json["data"] as! [String:AnyObject]
                    AppStatus.sharedInstance.userInfo.inviter = infodata["inviter"] as! String
                    AppStatus.sharedInstance.userInfo.invitation = infodata["code"] as! String
                    AppStatus.sharedInstance.vipInfo.endYear = Int(infodata["expire_year"] as! String)!
                    AppStatus.sharedInstance.vipInfo.endMonth = Int(infodata["expire_month"] as! String)!
                    AppStatus.sharedInstance.vipInfo.endDay = Int(infodata["expire_day"] as! String)!
                    AppStatus.sharedInstance.parentInfo.username = infodata["parent"] as! String
                    AppStatus.sharedInstance.parentInfo.endYear = Int(infodata["uexpire_year"] as! String)!
                    AppStatus.sharedInstance.parentInfo.endMonth = Int(infodata["uexpire_month"] as! String)!
                    AppStatus.sharedInstance.parentInfo.endDay = Int(infodata["uexpire_day"] as! String)!
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
                    let C = comp.day! >= AppStatus.sharedInstance.vipInfo.endDay
                    if((A) || (AE && B) || (AE && BE && C)){
                        AppStatus.sharedInstance.isVip = false
                    }else{
                        AppStatus.sharedInstance.isVip = true
                    }
                    let UA = comp.year! > AppStatus.sharedInstance.parentInfo.endYear
                    let UAE = comp.year! == AppStatus.sharedInstance.parentInfo.endYear
                    let UB = comp.month! > AppStatus.sharedInstance.parentInfo.endMonth
                    let UBE = comp.month! == AppStatus.sharedInstance.parentInfo.endMonth
                    let UC = comp.day! >= AppStatus.sharedInstance.parentInfo.endDay
                    if((UA) || (UAE && UB) || (UAE && UBE && UC)){
                        AppStatus.sharedInstance.upisVip = false
                    }else{
                        AppStatus.sharedInstance.upisVip = true
                    }
                    NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: nil)
                    print("up is VIP: \(AppStatus.sharedInstance.upisVip), You are VIP: \(AppStatus.sharedInstance.isVip)")
                }
            }
            task.resume()
        }
    }
}

class RegisterInfo{
    var userId:String
    var password:String
    var qq:String
    var wechat:String
    var taobao:String
    var invitation:String
    var email:String
    init(){
        userId = ""
        password = ""
        qq = ""
        wechat = ""
        taobao = ""
        invitation = ""
        email = ""
    }
    func clean(){
        userId = ""
        password = ""
        qq = ""
        wechat = ""
        taobao = ""
        invitation = ""
        email = ""
    }
}

class UserInfo{
    var userId:String
    var password:String
    var balance:String
    var qq:String
    var wechat:String
    var taobao:String
    var invitation:String
    var inviter:String
    var email:String
    var type:String
    var level:String
    var unRead:Int
    init(){
        userId = ""
        password = ""
        balance = ""
        qq = ""
        wechat = ""
        taobao = ""
        invitation = ""
        inviter = ""
        email = ""
        type = ""
        level = ""
        unRead = 0
    }
    func clean(){
        userId = ""
        password = ""
        balance = ""
        qq = ""
        wechat = ""
        taobao = ""
        invitation = ""
        inviter = ""
        email = ""
        type = ""
        level = ""
        unRead = 0
    }
}

class VipInfo{
    var startYear:Int
    var startMonth:Int
    var startDay:Int
    
    var endYear:Int
    var endMonth:Int
    var endDay:Int
    init(){
        startYear = 2016
        startMonth = 1
        startDay = 1
        
        endYear = 2017
        endMonth = 12
        endDay = 14
    }
    func clean(){
        startYear = 2016
        startMonth = 1
        startDay = 1
        
        endYear = 2016
        endMonth = 1
        endDay = 1
    }
}
class ParentInfo{
    var username:String
    var startYear:Int
    var startMonth:Int
    var startDay:Int
    
    var endYear:Int
    var endMonth:Int
    var endDay:Int
    init(){
        username = ""
        startYear = 2016
        startMonth = 1
        startDay = 1
        
        endYear = 2017
        endMonth = 12
        endDay = 14
    }
    func clean(){
        username = ""
        startYear = 2016
        startMonth = 1
        startDay = 1
        
        endYear = 2016
        endMonth = 1
        endDay = 1
    }
}

class UserServer{
    let register_url:String = "https://user.vsusvip.com:10000/register"
    let charge_url:String = "https://user.vsusvip.com:10000/charge"
    let query_url:String = "https://user.vsusvip.com:10000/query"
    let login_url:String = "https://user.vsusvip.com:10000/login1"
    let up2vip_url:String = "https://user.vsusvip.com:10000/up2vip"
    let extendvip_url:String = "https://user.vsusvip.com:10000/extendvip"
    let extendagent_url:String = "https://user.vsusvip.com:10000/extendagent"
    let newMessageCheck_url:String = "http://user.vsusvip.com:30000/check"
}

class ContentServer{
    let versionCheckURL:String = "http://user.vsusvip.com:13420/ios"
    var alimamaUrl:String = "http://pub.alimama.com"
}
