//
//  TabBarController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/10.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addChildController() {
        let vc1 = MainViewController()
        let vc2 = ChartViewController()
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
