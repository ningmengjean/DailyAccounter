//
//  UINavigationControllerExtention.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/4/25.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
    public func popViewController(animated: Bool,
                                  completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }
}
