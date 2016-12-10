//
//  MessageTableViewCell.swift
//  IOSrome
//
//  Created by 韩建桥 on 2016/12/10.
//  Copyright © 2016年 Lanchitour. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var action: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
