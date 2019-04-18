//
//  ArrayExtention.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/4/17.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation

extension Collection where Element: Equatable {
    var orderedSet: [Element]  {
        var array: [Element] = []
        return compactMap {
            if array.contains($0) {
                return nil
            } else {
                array.append($0)
                return $0
            }
        }
    }
}
