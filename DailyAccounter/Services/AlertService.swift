//
//  AlertService.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/1/11.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import UIKit

class AlertService {
    
    private init() {}
    
    static func addAlert(in vc: UIViewController,
                         completion: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "This member is already exit.", message: nil, preferredStyle: .alert)
       
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
