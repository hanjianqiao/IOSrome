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
