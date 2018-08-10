//
//  AccountData.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/6.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//

import Foundation
import RealmSwift

class AccountData: Object {
    @objc dynamic var date = Date()
    @objc dynamic var total: Float = 0.0
    open let costs = List<Cost>()
    open let incomes = List<Income>()
    
    class func defaultDay() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-DD"
        return dateFormat.string(from: Date())
    }
    
    override open class func primaryKey() -> String {
        return "date"
    }
}

class Cost: Object {
    @objc dynamic var date = Date()
    @objc dynamic var cost: Float = 0.0
    @objc dynamic var detail: String?
    @objc dynamic var budget: Float = 5000
    @objc dynamic var isBeyondBudgeting = false
    @objc dynamic var person: String?
    open let category = List<Category>()
}

class Income: Object {
    @objc dynamic var date = Date()
    @objc dynamic var income: Float = 0.0
    @objc dynamic var detail: String?
    @objc dynamic var person: String?
}

class Category: Object {
    @objc dynamic var name: String?
    @objc dynamic var imageView: UIImageView?
}













