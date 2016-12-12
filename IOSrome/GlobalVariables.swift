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
    init(){
        isLoggedIn = false
        userID = ""
        grantToken = ""
        isVip = false
        regInfo = RegisterInfo()
        server = ServerInfo()
        path = ServerPath()
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

class ServerInfo{
    let address:String = "www.kouchenvip.com"
    let port:String = "5000"
}

class ServerPath{
    let register:String = "register"
    let login:String = "login"
}
