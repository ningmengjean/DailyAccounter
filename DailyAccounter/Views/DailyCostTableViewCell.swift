//
//  DailyCostTableViewCell.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/4/2.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class DailyCostTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var outCategoryLabel: UILabel!
    @IBOutlet weak var outAmountLabel: UILabel!
    @IBOutlet weak var outDetailLabel: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
