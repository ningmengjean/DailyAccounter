//
//  UIColorExtention.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/22.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random() % 256) / 255.0
        let g = CGFloat(arc4random() % 256) / 255.0
        let b = CGFloat(arc4random() % 256) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
