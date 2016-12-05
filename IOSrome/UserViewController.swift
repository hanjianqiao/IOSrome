//
//  UserViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/4.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit


class UserViewController: UIViewController, URLSessionDelegate {
    @IBOutlet weak var serverURL: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func makeGetCall() {
        let request = NSMutableURLRequest(url: NSURL(string: "https://cart.taobao.com/json/GetPriceVolume.do?sellerId=763968012")! as URL)
        
       // request.timeoutInterval = 20.0 //(number as! NSTimeInterval)
       // request.httpMethod = "GET"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       // request.setValue("gzip", forHTTPHeaderField: "Accept-encoding")
        
        let configuration =
            URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration,
                                   delegate: self,
                                   delegateQueue:OperationQueue.main)
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else {                                   // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            //print(response ?? <#default value#>)
            //print(data)
            let cfEnc = CFStringEncodings.GB_18030_2000
            let enc = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfEnc.rawValue))
            let responseString = String(data: data, encoding: String.Encoding(rawValue: enc))!
            print("responseString = \(responseString)")
        }
        task.resume()

    }
    
    
    @IBAction func postJSON(_ sender: UIButton) {
        var request = URLRequest(url: URL(string: serverURL.text!)!)
        request.httpMethod = "POST"
        let postString = "{\"user_id\":\"SF-Zhou\",\"password\":\"ABCDEFG\",\"code\":\"123456\",\"wechat\":\"123456\",\"qq\":\"123456\",\"taobao\":\"123456\"}"
        request.httpBody = postString.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            print(data)
            let responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
        }
        task.resume()
        makeGetCall()
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
