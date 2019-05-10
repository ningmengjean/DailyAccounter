//
//  MonthlyAmount.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/8.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import RealmSwift

class MonthlyAmount {
    
    var monthlyIncome: Float = 0.0
    var monthlyCost: Float = 0.0
    
    func countMonthlyAmount(month: String) {
        let predicate = NSPredicate(format: "date BEGINSWITH %@", month)
        var monthlyIncome: Float = 0.0
        var monthlyCost: Float = 0.0
        if let monthlyAmounts = RealmService.shared.object(Amount.self)?.filter(predicate).toArray(ofType: Amount.self) {
            for amount in monthlyAmounts {
                if amount.isCost {
                    monthlyCost += amount.amount
                } else {
                    monthlyIncome += amount.amount
                }
            }
            self.monthlyCost = monthlyCost
            self.monthlyIncome = monthlyIncome
        }
    }
    
}
