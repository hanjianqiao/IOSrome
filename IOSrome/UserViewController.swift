//
//  UserViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/4.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, URLSessionDelegate, UITextFieldDelegate {
    
    let serverUrlString = "http://kouchenvip.com:5000/register"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "用户注册"
        
        self.text_username.delegate = self
        self.text_password.delegate = self
        self.text_password.isSecureTextEntry = true
        self.text_confirm.delegate = self
        self.text_confirm.isSecureTextEntry = true
        self.text_invitecode.delegate = self
        self.text_wechat.delegate = self
        self.text_qq.delegate = self
        self.text_taobao.delegate = self
        self.text_email.delegate = self
        
        text_username.returnKeyType = UIReturnKeyType.done
        text_password.returnKeyType = UIReturnKeyType.done
        text_confirm.returnKeyType = UIReturnKeyType.done
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
    
    @IBOutlet weak var text_username: UITextField!
    @IBOutlet weak var text_password: UITextField!
    @IBOutlet weak var text_confirm: UITextField!
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
        var request = URLRequest(url: URL(string: serverUrlString)!)
        request.httpMethod = "POST"
        let postString = "{\"user_id\":\"" +
            text_username.text! + "\",\"password\":\"" +
            text_password.text! + "\",\"code\":\"" +
            text_invitecode.text! + "\",\"wechat\":\"" +
            text_wechat.text! + "\",\"qq\":\"" +
            text_qq.text! + "\",\"taobao\":\"" +
            text_taobao.text! + "\"}"
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
            
            let alert1 = UIAlertController (title: "注册结果", message: responseString
                , preferredStyle: UIAlertControllerStyle.alert)
            alert1.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert1, animated: true, completion: nil)
        }
        task.resume()
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
