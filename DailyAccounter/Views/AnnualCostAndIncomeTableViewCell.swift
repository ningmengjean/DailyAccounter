//
//  AnnualCostAndIncomeTableViewCell.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/23.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class AnnualCostAndIncomeTableViewCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureAnnualCostAndIncomeTableViewCell(_ income:[(key: String, values:[Amount?])], cost:[(key: String, values:[Amount?])],indexPath: IndexPath) {
        if  indexPath.row == 0 {
            monthLabel.text = "日期"
            incomeLabel.text = "收入"
            costLabel.text = "支出"
            differenceLabel.text = "结余"
        } else if income[indexPath.row].values.count == 0 && cost[indexPath.row].values.count == 0 {
            self.isHidden = true
        } else {
            monthLabel.text = income[indexPath.row].key
            incomeLabel.text = String(income[indexPath.row].values.reduce(0.0){$0 + ($1?.amount ?? 0.0)})
            costLabel.text = String(cost[indexPath.row].values.reduce(0.0){$0 + ($1?.amount ?? 0.0)})
            let incomeValue = Double(incomeLabel.text!)
            let costValue = Double(costLabel.text!)
            differenceLabel.text = String(incomeValue! - costValue!)
        }
    }
}

