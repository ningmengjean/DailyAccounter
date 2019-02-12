//
//  Members.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/2/6.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import RealmSwift

class Member: Object {
    @objc dynamic var member = ""
    @objc dynamic var `default`: Int = 0
}

class MemberCollection: Object {
    let memberArray = List<Member>()
}
