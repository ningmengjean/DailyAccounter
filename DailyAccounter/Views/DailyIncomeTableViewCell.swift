//
//  DailyIncomeTableViewCell.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/4/6.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class DailyIncomeTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var inCategory: UILabel!
    @IBOutlet weak var inAmount: UILabel!
    @IBOutlet weak var inDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
