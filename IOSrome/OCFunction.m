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
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"taokezhushou_plugin" forKey: NSHTTPCookieName];
    [cookieProperties setObject:@"eyJpdiI6IkNteUtiQnlyV1NYNUdvTWx2Y3p4Z2c9PSIsInZhbHVlIjoiNmQyNEREdDZNXC8zcDBtWllwemxCS2RkNm1SdWlcLzk2SzRURTRRWlI2WDlVZVRsZFNpMVB0XC8rcFFMT2ltUXRZa1wvUWxoczRuZUVZUGlVdTU3VEV3Nm5BPT0iLCJtYWMiOiIyMDQxYTZkZDc3MmQ3OTUyZTY5Yjc1NDI1NTM5ODQ5ZTEwMjE4N2RhOGNkZjkwNmY4ZDk1Y2MwYTM4NzI0YmU0In0%3D" forKey: NSHTTPCookieValue];
    [cookieProperties setObject:@"zhushou3.taokezhushou.com" forKey: NSHTTPCookieDomain];
    [cookieProperties setObject:@"zhushou3.taokezhushou.com" forKey: NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey: NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey: NSHTTPCookieVersion];
    
    //[cookieProperties setObject:[[NSDate] ] forKey:NSHTTPCookieExpires]
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

@end
