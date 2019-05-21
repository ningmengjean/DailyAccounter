//
//  CategoryChartTableViewCell.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/18.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class CategoryChartTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var precentLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ amounts: [String: [Amount]], indexPath: IndexPath) {
        var total = 0.0
        for amount in amounts {
            total += Double(amount.value.reduce(0.0) { $0 + $1.amount})
        }
        let amount = amounts.compactMap {$0}[indexPath.row]
        categoryImageView.image = UIImage(named: amount.key)
        categoryLabel.text = amount.key
        precentLabel.text = String(format: "%.2f", (Double(amount.value.reduce(0.0) { $0 + $1.amount }) / total*100))+"%"
        amountLabel.text = String(amount.value.reduce(0.0) { $0 + $1.amount })
        
    }
    
}
