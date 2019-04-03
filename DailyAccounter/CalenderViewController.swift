//
//  CalenderViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/3/28.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController {
    
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var calenderView = UIView()
    fileprivate weak var calendar: FSCalendar!
    var selectedDay = String()
    var sendSelectedDay: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visualEffectView.frame = self.view.bounds
        self.view.addSubview(visualEffectView)
        calenderView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-350, width: UIScreen.main.bounds.width, height: 350)
        calenderView.backgroundColor = .white
        self.view.addSubview(calenderView)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        visualEffectView.addGestureRecognizer(tapRecognizer)
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-350, width: UIScreen.main.bounds.width, height: 350))
        calendar.dataSource = self as? FSCalendarDataSource
        calendar.delegate = self as? FSCalendarDelegate
        view.addSubview(calendar)
        self.calendar = calendar
    }
    
    @objc func dismissViewController() {
        selectedDay = calendar.selectedDate?.dateToString() ?? calendar.today!.dateToString()
        if let sendSelectdDay = self.sendSelectedDay {
            sendSelectdDay(selectedDay)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
