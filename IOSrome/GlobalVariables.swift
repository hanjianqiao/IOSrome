//
//  GlobalVariables.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/9.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import Foundation

class AppStatus {
    class var sharedInstance: AppStatus {
        struct Static {
            static let instance = AppStatus()
        }
        return Static.instance
    }
    var regInfo:RegisterInfo
    var isLoggedIn:Bool
    var userID:String
    var grantToken:String
    var isVip:Bool
    var server:ServerInfo
    var path:ServerPath
    var vipInfo:VipInfo
    init(){
        isLoggedIn = false
        userID = ""
        grantToken = ""
        isVip = false
        regInfo = RegisterInfo()
        server = ServerInfo()
        path = ServerPath()
        vipInfo = VipInfo()
    }
}

class RegisterInfo{
    var userId:String
    var password:String
    var qq:String
    var wechat:String
    var taobao:String
    var invitation:String
    init(){
        userId = ""
        password = ""
        qq = ""
        wechat = ""
        taobao = ""
        invitation = ""
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
        
        endYear = 2016
        endMonth = 1
        endDay = 1
    }
}

class ServerInfo{
    let address:String = "https://secure.hanjianqiao.cn"
    let port:String = ":5000"
}

class ServerPath{
    let register:String = "/register"
    let login:String = "/login"
}
