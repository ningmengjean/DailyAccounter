//
//  PersonCost.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/4/10.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import RealmSwift

class PersonCost: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var perPersonCost: Float = 0.0
    convenience  init(person: String, perPersonCost: Float) {
        self.init()
        self.name = person
        self.perPersonCost = perPersonCost
    }
    let amounts = LinkingObjects(fromType: Amount.self, property: "persons")
}

