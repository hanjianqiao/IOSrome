//
//  OCFunction.m
//  IOSrome
//
//  Created by 韩建桥 on 2016/11/29.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CustomeObject.h"

@implementation CustomObject

- (void) someMethod{
    /****/
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"taokezhushou_plugin" forKey: NSHTTPCookieName];
    [cookieProperties setObject:@"eyJpdiI6InFBK3dYMGdkZDBhR2lwTWljb3NHUXc9PSIsInZhbHVlIjoiU0ZrMDd0ZnpvMndSKzBDeFBUNElucktmRHpYcktnM28yZkQzV3A3VnlpV1dZY1hHQlNCWkxDTFBcL1h4Z0xHeldRRCtZWGxQb1ZYRHNlNDVQVnVjTXNRPT0iLCJtYWMiOiJjYTY1NTlhNjAzYjA2NGVkNzI4NDRjNjJiODIwMmRmYjA2OWMwMzgxNDc2NTU5MWE2NzFiMTU5MTE4ZmQ3YTU1In0%3D" forKey: NSHTTPCookieValue];
    [cookieProperties setObject:@"zhushou3.taokezhushou.com" forKey: NSHTTPCookieDomain];
    [cookieProperties setObject:@"zhushou3.taokezhushou.com" forKey: NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey: NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey: NSHTTPCookieVersion];
    
    //[cookieProperties setObject:[[NSDate] ] forKey:NSHTTPCookieExpires]
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    /****/
    NSMutableDictionary *cookieProperties1 = [NSMutableDictionary dictionary];
    [cookieProperties1 setObject:@"acw_tc" forKey: NSHTTPCookieName];
    [cookieProperties1 setObject:@"AQAAAOlOq3meUwQABYE4dLEV/pUy687M" forKey: NSHTTPCookieValue];
    [cookieProperties1 setObject:@"zhushou3.taokezhushou.com" forKey: NSHTTPCookieDomain];
    [cookieProperties1 setObject:@"zhushou3.taokezhushou.com" forKey: NSHTTPCookieOriginURL];
    [cookieProperties1 setObject:@"/" forKey: NSHTTPCookiePath];
    [cookieProperties1 setObject:@"0" forKey: NSHTTPCookieVersion];
    
    //[cookieProperties setObject:[[NSDate] ] forKey:NSHTTPCookieExpires]
    
    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookieProperties1];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
    
    /****/
    NSMutableDictionary *cookieProperties2 = [NSMutableDictionary dictionary];
    [cookieProperties2 setObject:@"XSRF-TOKEN" forKey: NSHTTPCookieName];
    [cookieProperties2 setObject:@"eyJpdiI6Ik1TeFVvcFhqWndhTjQ0aStKeEFVNnc9PSIsInZhbHVlIjoiVEZEWDRtZEVmeSttVkJud1VLbFhJQnMza05uVmtCWTl0cUJxWHY2K1lcL2Vza2JEZDI2V1FpRFE2eXp1YXE2bW5LemtsUmI5ZkZkRDVEckFjUWdlejF3PT0iLCJtYWMiOiJjOTFmMTRkNGQ3NDY0ZDA4NmM4YWM4N2NjYjhiMzdhYmY1YTE0MDE0ZTk3ZjJjOTY4NTY1Mzc0NjMwNjc1MjkzIn0%3D" forKey: NSHTTPCookieValue];
    [cookieProperties2 setObject:@"zhushou3.taokezhushou.com" forKey: NSHTTPCookieDomain];
    [cookieProperties2 setObject:@"zhushou3.taokezhushou.com" forKey: NSHTTPCookieOriginURL];
    [cookieProperties2 setObject:@"/" forKey: NSHTTPCookiePath];
    [cookieProperties2 setObject:@"0" forKey: NSHTTPCookieVersion];
    
    //[cookieProperties setObject:[[NSDate] ] forKey:NSHTTPCookieExpires]
    
    NSHTTPCookie *cookie2 = [NSHTTPCookie cookieWithProperties:cookieProperties2];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie2];
    
}

@end
