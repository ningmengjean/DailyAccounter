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
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var detail: String?
    @objc dynamic var category: String?
    @objc dynamic var isCost: Bool = false
    @objc dynamic var id: Int = 0
    let persons = List<PersonCost>()
    
    convenience init(date: String?, amount: Double, detail: String?, category: String?, isCost: Bool, costPerPerson: Float, id: Int) {
        self.init()
        self.date = date
        self.amount = amount
        self.detail = detail
        self.category = category
        self.isCost = isCost
        self.id = id
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func incrementID() -> Int {
        let currentMax = RealmService.shared.realm.objects(Amount.self).max(ofProperty: "id") as Int? ?? 0
        return currentMax + 1
    }
    
    class func defaultDay() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd"
        return dateFormat.string(from: Date())
    }
}















