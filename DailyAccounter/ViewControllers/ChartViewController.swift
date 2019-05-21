//
//  CharViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/10.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController, RefreshChartsDelegate, switchShowIncomeOrCostChartDelegate{
    
    func refreshIncomeCharts() {
        pieChartsView.values = [String:[Amount]]()
        tableViewValues = [String:[Amount]]()
        pieChartModel.countMonthlyIncomeAmount(month: datePickerView.dateLabel.text!)
        pieChartsView.values = pieChartModel.incomeCategoryAmountArray
        tableViewValues = pieChartsView.values
        pieChartsView.centerText = "总收入"
        
        if pieChartsView.values.count == 0 {
            noDataView.isHidden = false
        } else {
            noDataView.isHidden = true
            pieChartsView.setupChart()
            pieChartsView.loadChartData()
            tableView.reloadData()
        }
        
    }
    
    func switchShowIncomeOrCostChart(_ sender: UIButton) {
        if datePickerView.showCost {
            refreshIncomeCharts()
            datePickerView.showCost = false
        } else {
            refreshCostCharts()
            datePickerView.showCost = true
        }
    }
    
    func refreshCostCharts() {
        pieChartsView.values = [String:[Amount]]()
        tableViewValues = [String:[Amount]]()
        pieChartModel.countMonthlyCostAmount(month: datePickerView.dateLabel.text!)
        pieChartsView.values = pieChartModel.costCategoryAmountArray
        tableViewValues = pieChartsView.values
        pieChartsView.centerText = "总支出"
        
        if pieChartsView.values.count == 0 {
            noDataView.isHidden = false
        } else {
            noDataView.isHidden = true
            pieChartsView.setupChart()
            pieChartsView.loadChartData()
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func changeSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            datePickerView.pickMode = .pickMonthYear
            datePickerView.dateLabel.text = datePickerView.currentDate.toFormattedYearMonthString()
            datePickerView.exchangeButton.isHidden = false
        default:
            datePickerView.pickMode = .pickYear
            datePickerView.dateLabel.text = datePickerView.currentDate.toFormattedYearString()
            datePickerView.exchangeButton.isHidden = true 
        }
    }
    
    let datePickerView = gk_initViewFromNib(withType: DatePickerView.self)
    let tableView = UITableView()
    var pieChartsView = PieChartsView()
    let pieChartModel = PieChartModel()
    let noDataView = UIView()
    var tableViewValues = [String:[Amount]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CategoryChartTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CategoryChartTableViewCell")
        datePickerView.frame = CGRect(x: 0, y: 74, width: UIScreen.main.bounds.width, height: 40)
        datePickerView.backgroundColor = UIColor.init(red: 240, green: 240, blue: 240, alpha: 1)
        tableView.frame = CGRect(x: 0, y: 114, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-40-20)
        tableView.delegate = self
        tableView.dataSource = self
        datePickerView.refreshDelegate = self
        datePickerView.delegate = self
        let frame = self.tableView.frame
        noDataView.frame = frame
        noDataView.backgroundColor = .lightGray
        let noDataLable = UILabel(frame: CGRect(x: frame.width/2 - 60, y: frame.height/2-80 , width: 100, height: 40))
        noDataLable.text = "报表无数据"
        noDataLable.textAlignment = .center
        noDataView.isHidden = true
        noDataView.addSubview(noDataLable)
        self.view.addSubview(datePickerView)
        self.view.addSubview(tableView)
        self.view.addSubview(noDataView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pieChartModel.countMonthlyCostAmount(month: datePickerView.dateLabel.text!)
        pieChartsView.values = pieChartModel.costCategoryAmountArray
        tableViewValues = pieChartsView.values
        if pieChartsView.values.count == 0 {
            noDataView.isHidden = false
        } else {
            noDataView.isHidden = true
            pieChartsView.setupChart()
            pieChartsView.loadChartData()
            tableView.reloadData()
        }
        pieChartsView.centerText = "总支出"
    }
}

extension ChartViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewValues.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryChartTableViewCell") as! CategoryChartTableViewCell
        cell.configureCell(tableViewValues,indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        pieChartsView.backgroundColor = .white
        pieChartsView.frame.size = CGSize(width: 300, height: 300)
        pieChartsView.center = view.center
        return pieChartsView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
}
