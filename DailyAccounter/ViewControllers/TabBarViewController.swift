//
//  TabBarViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/23.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarItem = UITabBarItem(title: "报表", image: UIImage(named: "pie"), tag: 1)
        self.tabBarItem = tabBarItem
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
