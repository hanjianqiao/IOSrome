//
//  BuyVIPViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/11.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class BuyVIPViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    let serverUrlString = AppStatus.sharedInstance.server.address + AppStatus.sharedInstance.server.port + AppStatus.sharedInstance.path.login
    
    @IBAction func buyVIP(_ sender: UIButton) {
        let queue = OperationQueue()
        
        // do something immediately
        let alertLogging = UIAlertController (title: "购买VIP", message: "请稍后。。。"
            , preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertLogging, animated: true, completion: nil)
        
        queue.addOperation() {
            // do something in the background
            var request = URLRequest(url: URL(string: self.serverUrlString)!)
            request.httpMethod = "POST"
            let postString = "{}"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                
                guard let data = data, error == nil else {               // check for fundamental networking error
                    print("error=\(error)")
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
                    if(json["status"] as! String == "ok"){
                        OperationQueue.main.addOperation {
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

                        }
                    }else{
                        OperationQueue.main.addOperation {
                            alertLogging.dismiss(animated: true, completion: nil)
                            let alert = UIAlertController (title: "购买请求失败", message: responseString
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }
            task.resume()
        }

        /*
         let xml = SWXMLHash.parse(postString)
         
         for i in xml.children{
         for j in i.children{
         print(j.element?.text! ?? "")
         }
         }
         //print(xml)
         */
        
        //AppStatus.sharedInstance.isVip = true
    }

    @IBAction func help(_ sender: UIButton) {
        let alert = UIAlertController (title: "帮助", message: "关注XX微信公众号，在线提问，7*24小时为您解答"
            , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
