//
//  StartRegisterViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/11.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class StartRegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var text_username: UITextField!
    @IBOutlet weak var text_password: UITextField!
    @IBOutlet weak var text_confirm: UITextField!
    
    @IBAction func startRegister(_ sender: UIButton) {
        if(text_password.text! != text_confirm.text!){
            let alert = UIAlertController (title: "密码不匹配", message: "两次输入的密码不匹配，请重新输入"
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        AppStatus.sharedInstance.regInfo.userId = text_username.text!
        AppStatus.sharedInstance.regInfo.password = text_password.text!
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "user_reg_add_detail"))! as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.text_username.delegate = self
        self.text_password.delegate = self
        self.text_password.isSecureTextEntry = true
        self.text_confirm.delegate = self
        self.text_confirm.isSecureTextEntry = true
        
        text_username.returnKeyType = UIReturnKeyType.done
        text_password.returnKeyType = UIReturnKeyType.done
        text_confirm.returnKeyType = UIReturnKeyType.done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
