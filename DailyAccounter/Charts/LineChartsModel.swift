//
//  LineChartsModel.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/22.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation

class LineChartsModel {
    
    var annualCostAmountArray = [(key: String, value: [Amount?])]()
    var annualIncomeAmountArray = [(key: String, value: [Amount?])]()
    var annualTotalCost = 0.0
    var annualTotalIncome = 0.0
    
    func countAnnualCostAmount(year: String) {
        var annualCostAmountArray = [String:[Amount?]]()
        var annualTotalCost = 0.0
        let monthArray = ["-01","-02","-03","-04","-05","-06","-07","-08","-09","-10","-11","-12"]
        for num in monthArray {
            let predicate = NSPredicate(format: "date BEGINSWITH %@ AND isCost = true", year+num)
            let resultArray = RealmService.shared.object(Amount.self)?.filter(predicate).toArray(ofType: Amount.self)
            if resultArray != nil {
                annualCostAmountArray[year+num] = resultArray
                for amount in resultArray! {
                    annualTotalCost += amount.amount
                }
            } else {
                annualCostAmountArray[year+num] = [nil]
            }
        }
        let result = annualCostAmountArray.sorted{$0.0 < $1.0}

        self.annualCostAmountArray = result
        self.annualTotalCost = annualTotalCost
    }
    
    func countAnnualIncomeAmount(year: String) {
        var annualIncomeAmountArray = [String:[Amount?]]()
        var annualTotalIncome = 0.0
        let monthArray = ["-01","-02","-03","-04","-05","-06","-07","-08","-09","-10","-11","-12"]
        for num in monthArray {
            let predicate = NSPredicate(format: "date BEGINSWITH %@ AND isCost = false", year+num)
            let resultArray = RealmService.shared.object(Amount.self)?.filter(predicate).toArray(ofType: Amount.self)

            if resultArray != nil {
                annualIncomeAmountArray[year+num] = resultArray
                for amount in resultArray! {
                    annualTotalIncome += amount.amount
                }
            } else {
                annualIncomeAmountArray[year+num] = [nil]
            }
        }
        self.annualIncomeAmountArray = annualIncomeAmountArray.sorted{$0.0 < $1.0}
        self.annualTotalIncome = annualTotalIncome
    }
}
