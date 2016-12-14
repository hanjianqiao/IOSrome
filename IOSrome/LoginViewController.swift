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
    
    let serverUrlString = AppStatus.sharedInstance.server.address + AppStatus.sharedInstance.server.port + AppStatus.sharedInstance.path.login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        password.isSecureTextEntry = true
        
        username.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: username.intrinsicContentSize.height, height: username.intrinsicContentSize.height))
        let image = UIImage(named: "手机号.png")
        imageView.image = image
        username.leftView = imageView
        
        password.leftViewMode = UITextFieldViewMode.always
        let imageViewP = UIImageView(frame: CGRect(x: 0, y: 0, width: username.intrinsicContentSize.height, height: username.intrinsicContentSize.height))
        let imageP = UIImage(named: "密码.png")
        imageViewP.image = imageP
        password.leftView = imageViewP
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgetPassword(_ sender: UIButton) {
        
        let client = TCPClient(address: "www.apple.com", port: 80)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(string: "GET / HTTP/1.0\n\n" ) {
            case .success:
                guard let data = client.read(1024*10) else { return }
                
                if let response = String(bytes: data, encoding: .utf8) {
                    print(response)
                }
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        
        let alert = UIAlertController (title: "Password Reset", message: "You forget the password", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

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
        let queue = OperationQueue()
        
        // do something immediately
        let alertLogging = UIAlertController (title: "正在登录", message: "请稍后。。。"
            , preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertLogging, animated: true, completion: nil)
        
        queue.addOperation() {
            // do something in the background
            var request = URLRequest(url: URL(string: self.serverUrlString)!)
            request.httpMethod = "POST"
            let postString = "{\"user_id\":\"" +
                self.username.text! + "\",\"password\":\"" +
                self.password.text! + "\"}"
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
                
                alertLogging.dismiss(animated: true, completion:{
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
                            alertLogging.dismiss(animated: true, completion: nil)
                            let alert = UIAlertController (title: "登陆结果", message: responseString
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            }
            task.resume()

            OperationQueue.main.addOperation() {
                // when done, update your UI and/or model on the main queue
            }
        }
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
