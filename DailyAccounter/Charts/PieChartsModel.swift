//
//  PieChartsModel.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/15.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation

class PieChartsModel {
    
    var totalMonthlyIncome: Float = 0.0
    var totalMonthlyCost: Float = 0.0
    var costCategoryAmountArray = [String:[Amount]]()
    var incomeCategoryAmountArray = [String:[Amount]]()
    
    func countMonthlyCostAmount(month: String) {
        let predicate = NSPredicate(format: "date BEGINSWITH %@ AND isCost = true", month)
        var monthlyCost: Float = 0.0
        var costCategoryAmountArray = [String:[Amount]]()
        if let monthlyCostAmounts = RealmService.shared.object(Amount.self)?.filter(predicate).sorted(byKeyPath: "date" ).toArray(ofType: Amount.self) {
            for amount in monthlyCostAmounts {
                if costCategoryAmountArray[amount.category!] == nil {
                    costCategoryAmountArray[amount.category!] = [amount]
                } else {
                    costCategoryAmountArray[amount.category!]?.append(amount)
                }
                monthlyCost += amount.amount
            }
            self.totalMonthlyCost = monthlyCost
            self.costCategoryAmountArray = costCategoryAmountArray
        }
    }
    
    func countMonthlyIncomeAmount(month: String) {
        let predicate = NSPredicate(format: "date BEGINSWITH %@ AND isCost = False", month)
        var monthlyIncome: Float = 0.0
        var incomeCategoryAmountArray = [String:[Amount]]()
        if let monthlyIncomeAmounts = RealmService.shared.object(Amount.self)?.filter(predicate).sorted(byKeyPath: "date" ).toArray(ofType: Amount.self) {
            for amount in monthlyIncomeAmounts {
                if incomeCategoryAmountArray[amount.category!] == nil {
                    incomeCategoryAmountArray[amount.category!] = [amount]
                } else {
                    incomeCategoryAmountArray[amount.category!]?.append(amount)
                }
                monthlyIncome += amount.amount
            }
            self.totalMonthlyIncome = monthlyIncome
            self.incomeCategoryAmountArray = incomeCategoryAmountArray
        }
    }
}

