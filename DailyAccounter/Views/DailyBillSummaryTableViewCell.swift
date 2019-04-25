//
//  TodayBillSummaryTableViewCell.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/4/11.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class DailyBillSummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var IncomeLabel: UILabel!
    @IBOutlet weak var CostLabel: UILabel!
    @IBOutlet weak var inAmount: UILabel!
    @IBOutlet weak var outAmount: UILabel!
    @IBOutlet weak var labelBackView: UIView!
    
    let colorArr: [UIColor] = [.red,.lightGray,.green,.yellow]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let size:CGFloat = 30.0
        labelBackView.layer.cornerRadius = size/2
        labelBackView.backgroundColor = colorArr.randomElement()
        dateLabel.backgroundColor = UIColor.black.withAlphaComponent(0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
}

