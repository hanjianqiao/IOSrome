//
//  ReportViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/10.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var yesterdayButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yesterday(_ sender: UIButton) {
    }
    @IBAction func today(_ sender: UIButton) {
    }
    @IBAction func refresh(_ sender: UIButton) {
        let urlAlimama = URL(string: "http://pub.alimama.com/")
        let cookies = HTTPCookieStorage.shared.cookies(for: urlAlimama!)
        var tbtoken:String = ""
        for cookie in cookies!{
            if(cookie.name == "_tb_token_"){
                tbtoken = cookie.value
            }
        }
        let url = "http://pub.alimama.com/overview/unionaccountinfo.json?_tb_token_="+tbtoken+"&_input_charset=utf-8"
        
        let requestDetail = URLRequest(url: URL(string: url)!)
        let taskDetail = URLSession.shared.dataTask(with: requestDetail) { data, response, error in
            
            
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
            //print("responseString = \(responseString)")
            
            if(responseString.hasPrefix("<!")){
                print("Please login")
            }else{
                
                let str = responseString.substring(from: (responseString.range(of: "\"data\":")?.upperBound)!)
                let str0 = str.substring(to: (str.range(of: ",\"info\":")?.lowerBound)!)
                //print(str0)
                let json = JsonTools.convertToDictionary(text: str0)!
                
                let curr:String = String(describing: json["curMonthTotal"] as! Int)
                let last:String = String(describing: json["lastMonthTotal"] as! Int)
                let yest:String = String(describing: json["yesterdayTotal"] as! Int)
                
                print(curr)
                print(last)
                print(yest)
                
            }
            
        }
        taskDetail.resume()
        
        let urlBalance = "http://media.alimama.com/account/overview.htm"
        
        let request = URLRequest(url: URL(string: urlBalance)!)
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
            //print(responseString)
            let range = responseString.range(of: "\"J_balance\">")
            if(range == nil){
                print("Please login")
            }else{
                let str = responseString.substring(from: (range!.upperBound))
                let str0 = str.substring(to: (str.range(of: "</span><span")?.lowerBound)!)
                print(str0)
            }
            
        }
        task.resume()
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
