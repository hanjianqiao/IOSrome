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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerNewUser(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "UserStoryboard", bundle: nil).instantiateInitialViewController() as UIViewController!
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    @IBAction func forgetPassword(_ sender: UIButton) {
        let alert = UIAlertController (title: "Password Reset", message: "You forget the password", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    let serverUrlString = "http://kouchenvip.com:5000/login"

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
            
            let alert = UIAlertController (title: "登陆结果", message: responseString
                , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            OperationQueue.main.addOperation {
                self.present(alert, animated: true, completion: nil)
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
