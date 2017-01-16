//
//  GlobalVariables.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/9.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import Foundation

struct defaultsKeys {
    static let keyOne = "MessageUntilID"
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
    
    var isLoggedIn:Bool
    var userID:String
    var grantToken:String
    var isVip:Bool
    var regInfo:RegisterInfo
    var userServer:UserServer
    var contentServer:ContentServer
    var vipInfo:VipInfo
    var userInfo:UserInfo
    
    var db:SQLiteConnect? = nil
    func init_db(){
        // 資料庫檔案的路徑
        let sqlitePath = NSHomeDirectory() + "/Documents/sqlite3.db"
        
        // 印出儲存檔案的位置
        print(sqlitePath)
        
        // SQLite 資料庫
        db = SQLiteConnect(path: sqlitePath)!
        
        if let mydb = db {
            
            // create table
            _ = mydb.createTable(tableName: "students", columnsInfo: [
                "id integer primary key autoincrement",
                "name text",
                "height double"])
            
            // insert
            _ = mydb.insert(
                tableName: "students", rowInfo:
                ["name":"'大強'","height":"178.2"])
            
            // select
            let statement = mydb.fetch(
                tableName: "students", cond: "1 == 1", order: nil)
            while sqlite3_step(statement) == SQLITE_ROW{
                let id = sqlite3_column_int(statement, 0)
                let name = String(cString: sqlite3_column_text(statement, 1))
                let height = sqlite3_column_double(statement, 2)
                print("\(id). \(name) 身高： \(height)")
            }
            sqlite3_finalize(statement)
            
            // update
            _ = mydb.update(
                tableName: "students", 
                cond: "id = 1", 
                rowInfo: ["name":"'小強'","height":"176.8"])
            
            // delete
            _ = mydb.delete(tableName: "students", cond: "id = 5")
            
        }
    }
    init(){
        isLoggedIn = false
        userID = ""
        grantToken = ""
        isVip = false
        regInfo = RegisterInfo()
        userServer = UserServer()
        contentServer = ContentServer()
        vipInfo = VipInfo()
        userInfo = UserInfo()
        init_db()
    }
    func logout(){
        isLoggedIn = false
        userID = ""
        grantToken = ""
        isVip = false
        regInfo.clean()
        vipInfo.clean()
        userInfo.clean()
    }
    
    func periodCheck(){
        print("Period check...")
        if(AppStatus.sharedInstance.isLoggedIn == true){
            let defaults = UserDefaults.standard
            
            let mid = defaults.integer(forKey: defaultsKeys.keyOne)
            
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
                    print("error=\(error)")
                    return
                }
                let responseString = String(data: data, encoding: .utf8)!
                print(responseString)
                let prej = JsonTools.convertToDictionary(text: responseString)
                if((prej) != nil){
                    let json = prej!
                    if(json["status"] as! String == "ok"){
                        let nowid = json["message"] as! Int
                        print("nowid is \(nowid) and mid is \(mid)")
                        if(nowid > mid){
                            AppStatus.sharedInstance.userInfo.unRead = nowid - mid
                            NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: nil)
                        }
                    }
                }
            }
            task.resume()
        }
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
                    print("error=\(error)")
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
                    NotificationCenter.default.post(name: Notification.Name("update"), object: self, userInfo: nil)
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

class UserServer{
    let register_url:String = "https://secure.hanjianqiao.cn:10000/register"
    let charge_url:String = "https://secure.hanjianqiao.cn:10000/charge"
    let query_url:String = "https://secure.hanjianqiao.cn:10000/query"
    let login_url:String = "https://secure.hanjianqiao.cn:10000/login"
    let up2vip_url:String = "https://secure.hanjianqiao.cn:10000/up2vip"
    let extendvip_url:String = "https://secure.hanjianqiao.cn:10000/extendvip"
    let extendagent_url:String = "https://secure.hanjianqiao.cn:10000/extendagent"
    let newMessageCheck_url:String = "https://secure.hanjianqiao.cn:30000/check"
}

class ContentServer{
    let mainPageURL:String = "https://secure.hanjianqiao.cn:7741/A/index.html"
    let highBrokerPageURL:String = "https://secure.hanjianqiao.cn:7741/A/shop.html"
    let selfServiceMainPageURL:String = "https://secure.hanjianqiao.cn:7741/A/self.html"
    let selfServicePageURL:String = "https://secure.hanjianqiao.cn:7741/A/search.html"
    let detailShopPageURL:String = "https://secure.hanjianqiao.cn:7741/A/detail_shop.html"
    let detailSelfPageURL:String = "https://secure.hanjianqiao.cn:7741/A/detail_self.html"
    
    let money:String = "https://secure.hanjianqiao.cn:7741/A/user/money.html"
    let vipPageURL1:String = "https://secure.hanjianqiao.cn:7741/A/user/vip01.html"
    let vipPageURL2:String = "https://secure.hanjianqiao.cn:7741/A/user/vip02.html"
    let vipPageURL3:String = "https://secure.hanjianqiao.cn:7741/A/user/vip03.html"
    let agentPageURL1:String = "https://secure.hanjianqiao.cn:7741/A/user/agent-before.html"
    let agentPageURL2:String = "https://secure.hanjianqiao.cn:7741/A/user/agent.html"
    let agentPageURL3:String = "https://secure.hanjianqiao.cn:7741/A/user/mybill-list.html"
    let agentPageURL4:String = "https://secure.hanjianqiao.cn:7741/A/user/mybill.html"
    let tutorialPageURL:String = "https://secure.hanjianqiao.cn:7741/A/user/newcomer.html"
    let systemMessagePageURL:String = "https://secure.hanjianqiao.cn:7741/A/user/message.html"
    let systemMessageDetailPageURL:String = "https://secure.hanjianqiao.cn:7741/A/user/news.html"
    let aboutUsPageURL:String = "https://secure.hanjianqiao.cn:7741/A/user/about.html"
}
