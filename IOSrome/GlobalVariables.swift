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
    init(){
        isLoggedIn = false
        userID = ""
        grantToken = ""
        isVip = false
        regInfo = RegisterInfo()
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
