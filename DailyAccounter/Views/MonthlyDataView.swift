//
//  MonthlyDataView.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/9.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class MonthlyDataView: UIView {
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var incomeAmountLabel: UILabel!
    @IBOutlet weak var monthlyBackView: UIView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costAmountLabel: UILabel!
    
    let colorArr: [UIColor] = [.red,.lightGray,.green,.yellow]
    
    override func draw(_ rect: CGRect) {
        
    }
    var isInited = false
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isInited {
            let size:CGFloat = 60.0
            monthlyBackView?.layer.cornerRadius = size/2
            monthlyBackView?.backgroundColor = .red
            monthLabel?.backgroundColor = UIColor.black.withAlphaComponent(0)
        }
    }
}
