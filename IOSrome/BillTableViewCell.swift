//
//  BillTableViewCell.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/10.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {

    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
