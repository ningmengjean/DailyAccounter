//
//  DailyIncomeTableViewCell.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/4/3.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class DailyIncomeTableViewCell: UITableViewCell {
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var mountLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
