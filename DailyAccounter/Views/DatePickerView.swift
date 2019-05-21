//
//  DatePickerView.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/10.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import FSCalendar
protocol switchShowIncomeOrCostChartDelegate: class {
    func switchShowIncomeOrCostChart(_ sender: UIButton)
}
protocol RefreshChartsDelegate: class {
    func refreshCostCharts()
    func refreshIncomeCharts()
}

class DatePickerView: UIView {
    
    enum PickMode: Int {
        case pickMonthYear
        case pickYear
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    {
        didSet {
            switch pickMode {
            case .pickMonthYear:
                self.dateLabel.text = currentDate.toFormattedYearMonthString()
            case .pickYear:
                self.dateLabel.text = currentDate.toFormattedYearString()
            }
        }
    }
    @IBOutlet weak var preButton: UIButton! {
        didSet {
            self.preButton.setImage(UIImage(named: "pre"), for: .normal)
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet{
            self.nextButton.setImage(UIImage(named: "next"), for: .normal)
        }
    }
    @IBOutlet weak var exchangeButton: UIButton! {
        didSet {
            self.exchangeButton.setImage(UIImage(named: "exchange"), for: .normal)
        }
    }
    @IBAction func goToPreDate(_ sender: UIButton) {
        switch pickMode {
        case .pickMonthYear:
            let preMonth = currentDate.dateByAdding(months: -1)
            dateLabel.text = preMonth.toFormattedYearMonthString()
            currentDate = preMonth
            if showCost {
                pieChartModel.countMonthlyCostAmount(month: dateLabel.text!)
                refreshDelegate?.refreshCostCharts()
            } else {
                pieChartModel.countMonthlyIncomeAmount(month: dateLabel.text!)
                refreshDelegate?.refreshIncomeCharts()
            }
        case .pickYear:
            let preYear = currentDate.dateByAdding(years: -1)
            dateLabel.text = preYear.toFormattedYearString()
            currentDate = preYear
        }
    }
    @IBAction func goToNextDate(_ sender: UIButton) {
        switch pickMode {
        case .pickMonthYear:
            let nextMonth = currentDate.dateByAdding(months: 1)
            dateLabel.text = nextMonth.toFormattedYearMonthString()
            currentDate = nextMonth
            if showCost {
                pieChartModel.countMonthlyCostAmount(month: dateLabel.text!)
                refreshDelegate?.refreshCostCharts()
            } else {
                pieChartModel.countMonthlyIncomeAmount(month: dateLabel.text!)
                refreshDelegate?.refreshIncomeCharts()
            }
            case .pickYear:
            let nextYear = currentDate.dateByAdding(years: 1)
            dateLabel.text = nextYear.toFormattedYearString()
            currentDate = nextYear
        }
    }
    @IBAction func exchangeIncomeOrCost(_ sender: UIButton) {
        delegate?.switchShowIncomeOrCostChart(sender)
    }
    var pickMode = PickMode.pickMonthYear
    var currentDate = Date()
    weak var delegate: switchShowIncomeOrCostChartDelegate?
    weak var refreshDelegate: RefreshChartsDelegate?
    var pieChartModel = PieChartModel()
    var showCost = true
}
