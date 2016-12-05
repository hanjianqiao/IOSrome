//
//  OCFunction.m
//  IOSrome
//
//  Created by 韩建桥 on 2016/11/29.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CustomeObject.h"

#include<netdb.h>
#include<unistd.h>
#include<sys/socket.h>
#define BUFSIZE 10240



@implementation CustomObject
- (void) setCookie{
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
}
- (void) readHttp{
    int sockfd, portno;
    ssize_t n;
    struct sockaddr_in serveraddr;
    struct hostent *server;
    char *hostname;
    char buf[BUFSIZE];
    
    hostname = "shop.m.taobao.com";
    portno = 80;
    
    /* socket: create the socket */
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    /* gethostbyname: get the server's DNS entry */
    server = gethostbyname(hostname);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host as %s\n", hostname);
        exit(0);
    }
    
    /* build the server's Internet address */
    bzero((char *) &serveraddr, sizeof(serveraddr));
    serveraddr.sin_family = AF_INET;
    bcopy((char *)server->h_addr,
          (char *)&serveraddr.sin_addr.s_addr, server->h_length);
    serveraddr.sin_port = htons(portno);
    
    /* connect: create a connection with the server */
    if (connect(sockfd, (const struct sockaddr*)(&serveraddr), sizeof(serveraddr)) < 0)
        printf("ERROR connecting");
    
    /* get message line from the user */
    //printf("Please enter msg: ");
    //bzero(buf, BUFSIZE);
    //fgets(buf, BUFSIZE, stdin);
    
    /* send the message line to the server */
    const char * message1 = "GET /shop/coupon.htm?seller_id=2966269406&activity_id=d77c8bd5467a47a297d2ead939064f5b HTTP/1.1\r\nHost: shop.m.taobao.com\r\nConnection: keep-alive\r\nCache-Control: max-age=0\r\nUpgrade-Insecure-Requests: 1\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36\r\nAccept: textml,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nAccept-Encoding: gzip, deflate, sdch\r\nAccept-Language: en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4,zh-TW;q=0.2,ko;q=0.2\r\n\r\n";
    n = write(sockfd, message1, strlen(message1));
    
    /* print the server's reply */
    bzero(buf, BUFSIZE);
    n = read(sockfd, buf, BUFSIZE);
    printf("Echo from server: %s", buf);
    close(sockfd);
}
- (void) httpsRequest{
}

- (void) someMethod{
}

@end
