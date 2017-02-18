//
//  WelcomViewController.swift
//  IOSrome
//
//  Created by 韩建桥 on 2017/2/9.
//  Copyright © 2017年 Lanchitour. All rights reserved.
//

import UIKit

class WelcomViewController: UIViewController {

    @IBOutlet weak var urlText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToUrl(_ sender: UIButton) {
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "webkit"))! as! ViewController
        let strUrl:String = (urlText.text)!
        vc.mainUrl = strUrl
        self.navigationController?.pushViewController(vc, animated: true)
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
