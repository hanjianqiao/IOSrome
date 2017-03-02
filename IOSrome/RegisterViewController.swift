//
//  UserViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/4.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, URLSessionDelegate, UITextFieldDelegate {
    
    let serverUrlString = AppStatus.sharedInstance.userServer.register_url

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.title = "用户注册"
        
        
        self.text_invitecode.delegate = self
        self.text_wechat.delegate = self
        self.text_qq.delegate = self
        
        text_invitecode.returnKeyType = UIReturnKeyType.done
        text_wechat.returnKeyType = UIReturnKeyType.done
        text_qq.returnKeyType = UIReturnKeyType.done

        
        //1
        text_invitecode.frame.size.height = 40
        text_invitecode.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: text_invitecode.intrinsicContentSize.height+10, height: text_invitecode.intrinsicContentSize.height))
        imageView.image = UIImage(named: "邀请码.png")
        imageView.contentMode = UIViewContentMode.center
        text_invitecode.leftView = imageView
        //2
        text_wechat.frame.size.height = 40
        text_wechat.leftViewMode = UITextFieldViewMode.always
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: text_wechat.intrinsicContentSize.height+10, height: text_wechat.intrinsicContentSize.height))
        imageView2.image = UIImage(named: "微信.png")
        imageView2.contentMode = UIViewContentMode.center
        text_wechat.leftView = imageView2
        //3
        text_qq.frame.size.height = 40
        text_qq.leftViewMode = UITextFieldViewMode.always
        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: text_qq.intrinsicContentSize.height+10, height: text_qq.intrinsicContentSize.height))
        imageView3.image = UIImage(named: "QQ.png")
        imageView3.contentMode = UIViewContentMode.center
        text_qq.leftView = imageView3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var text_invitecode: UITextField!
    @IBOutlet weak var text_wechat: UITextField!
    @IBOutlet weak var text_qq: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    @IBOutlet weak var isAgreed: UISwitch!
  
    @IBAction func agreeSwitched(_ sender: UISwitch) {
        registerButton.isEnabled = isAgreed.isOn
    }
    
    @IBAction func doRegister(_ sender: UIButton) {
        let queue = OperationQueue()
        
        // do something immediately
        let alertLogging = UIAlertController (title: "注册中", message: "请稍后。。。"
            , preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertLogging, animated: true, completion: nil)
        
        queue.addOperation() {
            // do something in the background
            
            var request = URLRequest(url: URL(string: self.serverUrlString)!)
            request.httpMethod = "POST"
            let postString = "{\"user_id\":\"" +
                AppStatus.sharedInstance.regInfo.userId + "\",\"password\":\"" +
                AppStatus.sharedInstance.regInfo.password + "\",\"code\":\"" +
                self.text_invitecode.text! + "\",\"wechat\":\"" +
                self.text_wechat.text! + "\",\"qq\":\"" +
                self.text_qq.text! + "\"}"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {               // check for fundamental networking error
                    print("error=\(error)")
                    alertLogging.dismiss(animated: true, completion:{
                        OperationQueue.main.addOperation {
                            alertLogging.dismiss(animated: true, completion: nil)
                            let alert = UIAlertController (title: "网络异常", message: "请重试"
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
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
                OperationQueue.main.addOperation {
                    alertLogging.dismiss(animated: true, completion:{
                        let status:String = json["status"] as! String
                        let message:String = json["message"] as! String
                        if(status == "ok"){
                            var viewControllers = self.navigationController?.viewControllers
                            viewControllers?.removeLast(2) //views to pop
                            self.navigationController?.setViewControllers(viewControllers!, animated: true)
                        }else{
                            alertLogging.dismiss(animated: true, completion: nil)
                            let alert = UIAlertController (title: "注册结果", message: message
                                , preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
            task.resume()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func showAgreement(_ sender: UIButton) {
        let alert = UIAlertController (title: "服务协议", message: "这里是服务协议的细节内容"
            , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
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
