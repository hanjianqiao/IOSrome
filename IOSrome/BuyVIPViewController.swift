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
    
    @IBAction func buyVIP(_ sender: UIButton) {
        
        var request = URLRequest(url: URL(string: "https://api.mch.weixin.qq.com/sandbox/pay/unifiedorder")!)
        request.httpMethod = "POST"
        let postString = "<xml><appid>wx2421b1c4370ec43b</appid><attach>支付测试</attach><body>APP支付测试</body><mch_id>10000100</mch_id><nonce_str>1add1a30ac87aa2db72f57a2375d8fec</nonce_str><notify_url>http://wxpay.wxutil.com/pub_v2/pay/notify.v2.php</notify_url><out_trade_no>1415659990</out_trade_no><spbill_create_ip>14.23.150.211</spbill_create_ip><total_fee>1</total_fee><trade_type>APP</trade_type><sign>0CB01533B8C1EF103065174F50BCA001</sign></xml>"
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
            
        }
        task.resume()

        print("Buy vip...")
        let payRequest = PayReq()
        payRequest.partnerId = "10000100"
        payRequest.prepayId = "1101000000140415649af9fc314aa427"
        payRequest.package = "Sign=WXPay"
        payRequest.nonceStr = "a462b76e7436e98e0ed6e13c64b4fd1c"
        payRequest.timeStamp = 1397527777
        payRequest.sign =  "582282D72DD2B03AD892830965F428CB16E7A256"
        WXApi.send(payRequest)
        
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
