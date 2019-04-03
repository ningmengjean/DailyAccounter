//
//  DateExtention.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/3/30.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd"
        return dateFormat.string(from: self)
    }
}
