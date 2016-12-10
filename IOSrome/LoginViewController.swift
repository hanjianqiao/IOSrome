//
//  LoginViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/6.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        password.isSecureTextEntry = true
        
        username.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: username.intrinsicContentSize.height, height: username.intrinsicContentSize.height))
        let image = UIImage(named: "1启动页.jpg")
        imageView.image = image
        username.leftView = imageView
        
        password.leftViewMode = UITextFieldViewMode.always
        let imageViewP = UIImageView(frame: CGRect(x: 0, y: 0, width: username.intrinsicContentSize.height, height: username.intrinsicContentSize.height))
        let imageP = UIImage(named: "1启动页.jpg")
        imageViewP.image = imageP
        password.leftView = imageViewP
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        let alert = UIAlertController (title: "Password Reset", message: "You forget the password", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    let serverUrlString = "http://kouchenvip.com:5000/login"
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    @IBAction func doLogin(_ sender: UIButton) {
        var request = URLRequest(url: URL(string: serverUrlString)!)
        request.httpMethod = "POST"
        let postString = "{\"user_id\":\"" +
            username.text! + "\",\"password\":\"" +
            password.text! + "\"}"
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
            
            let json = self.convertToDictionary(text: responseString)!
            
            print(json["status"] as! String == "failed")
            print(json["message"]!)
            if(json["status"] as! String == "ok"){
                OperationQueue.main.addOperation {
                    AppStatus.sharedInstance.userID = self.username.text!
                    AppStatus.sharedInstance.grantToken = self.password.text!
                    AppStatus.sharedInstance.isLoggedIn = true
                    let preView = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2] as! UserCenterViewController
                    preView.updateUserView()
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }else{
                OperationQueue.main.addOperation {
                    let alert = UIAlertController (title: "登陆结果", message: responseString
                        , preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
        
    }
    
    @IBAction func WXPay(_ sender: UIButton) {
        let request = URLRequest(url: URL(string: "http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios")!)
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
            
            let json = self.convertToDictionary(text: responseString)!
            print(json)
            
            let alert = UIAlertController (title: "登陆结果", message: responseString
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            OperationQueue.main.addOperation {
                self.present(alert, animated: true, completion: nil)
            }
            
            
            let payRequest = PayReq()
            payRequest.partnerId = "10000100"
            payRequest.prepayId = "1101000000140415649af9fc314aa427"
            payRequest.package = "Sign=WXPay"
            payRequest.nonceStr = "a462b76e7436e98e0ed6e13c64b4fd1c"
            payRequest.timeStamp = 1397527777
            payRequest.sign =  "582282D72DD2B03AD892830965F428CB16E7A256"
            WXApi.send(payRequest)
            
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
