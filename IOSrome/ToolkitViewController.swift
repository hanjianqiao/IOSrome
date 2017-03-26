//
//  ToolkitViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/3/26.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit

class ToolkitViewController: UIViewController {

    @IBOutlet weak var alimama_username: UITextField!
    @IBOutlet weak var alimama_password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaults = UserDefaults.standard
        let saved_alimama_username = defaults.string(forKey: defaultsKeys.alimama_username)
        if(saved_alimama_username == nil){
            alimama_username.text = ""
        }else{
            alimama_username.text = saved_alimama_username!
        }
        let saved_alimama_password = defaults.string(forKey: defaultsKeys.alimama_password)
        if(saved_alimama_password == nil){
            alimama_password.text = ""
        }else{
            alimama_password.text = saved_alimama_password!
        }
    }

    @IBAction func aliamama_save(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.setValue(alimama_username.text!, forKey: defaultsKeys.alimama_username)
        defaults.setValue(alimama_password.text!, forKey: defaultsKeys.alimama_password)
    }
    @IBAction func alimama_clear(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: defaultsKeys.alimama_username)
        defaults.setValue("", forKey: defaultsKeys.alimama_password)
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
