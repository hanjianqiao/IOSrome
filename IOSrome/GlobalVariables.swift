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
}

class ContentServer{
    let mainPageURL:String = "https://secure.hanjianqiao.cn:7741/A/index.html"
    let highBrokerPageURL:String = "https://secure.hanjianqiao.cn:7741/A/shop.html"
    let selfServiceMainPageURL:String = "https://secure.hanjianqiao.cn:7741/A/self.html"
    let selfServicePageURL:String = "https://secure.hanjianqiao.cn:7741/A/search.html"
    let detailShopPageURL:String = "https://secure.hanjianqiao.cn:7741/A/detail_shop.html"
    let detailSelfPageURL:String = "https://secure.hanjianqiao.cn:7741/A/detail_self.html"
    
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
