//
//  AccountData.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/6.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//

import Foundation
import RealmSwift

class Amount: Object {
    @objc dynamic var date: String? = Amount.defaultDay()
    @objc dynamic var amount: Float = 0.0
    @objc dynamic var detail: String?
    @objc dynamic var category: String?
    @objc dynamic var isCost: Bool = false
    let persons = List<PersonCost>()
    
    convenience init(date: String?, amount: Float, detail: String?, category: String?, isCost: Bool, costPerPerson: Float) {
        self.init()
        self.date = date
        self.amount = amount
        self.detail = detail
        self.category = category
        self.isCost = isCost
    }
    
    class func defaultDay() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd"
        return dateFormat.string(from: Date())
    }
}















