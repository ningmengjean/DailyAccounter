//
//  MemberList.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/2/25.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import RealmSwift

class Member: Object {
    @objc dynamic var memberName: String?
    @objc dynamic var id: Int = 0
    @objc dynamic var isDefault: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, memberName: String?, isDefault: Bool) {
        self.init()
        self.id = id
        self.memberName = memberName
        self.isDefault = isDefault
    }
    
    func incrementID() -> Int {
        let currentMax = RealmService.shared.realm.objects(Member.self).max(ofProperty: "id") as Int? ?? 0
        return currentMax + 1
    }
}
