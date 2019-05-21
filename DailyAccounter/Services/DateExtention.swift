//
//  DateExtention.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/3/30.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation

extension Date {
    
    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    var month: Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    func toFormattedYearString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let converted = dateFormatter.string(from: self)
        return converted
    }
    
    func toFormattedYearMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM"
        let converted = dateFormatter.string(from: self)
        return converted
    }
    
    func dateToString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd"
        return dateFormat.string(from: self)
    }
    
    func dateByAdding(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
    
    func dateByAdding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
}
