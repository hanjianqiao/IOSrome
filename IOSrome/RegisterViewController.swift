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
        self.text_taobao.delegate = self
        self.text_email.delegate = self
        
        text_invitecode.returnKeyType = UIReturnKeyType.done
        text_wechat.returnKeyType = UIReturnKeyType.done
        text_qq.returnKeyType = UIReturnKeyType.done
        text_taobao.returnKeyType = UIReturnKeyType.done
        text_email.returnKeyType = UIReturnKeyType.done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var text_invitecode: UITextField!
    @IBOutlet weak var text_wechat: UITextField!
    @IBOutlet weak var text_qq: UITextField!
    @IBOutlet weak var text_taobao: UITextField!
    @IBOutlet weak var text_email: UITextField!
    @IBOutlet weak var registerButton: UIButton!

    @IBOutlet weak var isAgreed: UISwitch!
  
    @IBAction func agreeSwitched(_ sender: UISwitch) {
        registerButton.isEnabled = isAgreed.isOn
    }
    
    @IBAction func doRegister(_ sender: UIButton) {
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
                AppStatus.sharedInstance.regInfo.userId + "\",\"password\":\"" +
                AppStatus.sharedInstance.regInfo.password + "\",\"code\":\"" +
                self.text_invitecode.text! + "\",\"wechat\":\"" +
                self.text_wechat.text! + "\",\"qq\":\"" +
                self.text_qq.text! + "\",\"taobao\":\"" +
                self.text_taobao.text! + "\",\"email\":\"" +
                self.text_email.text! + "\"}"
            request.httpBody = postString.data(using: .utf8)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {               // check for fundamental networking error
                    print("error=\(error)")
                    alertLogging.dismiss(animated: true, completion:{
                        OperationQueue.main.addOperation {
                            alertLogging.dismiss(animated: true, completion: nil)
                            let alert = UIAlertController (title: "网络异常", message: "请重新登录"
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
