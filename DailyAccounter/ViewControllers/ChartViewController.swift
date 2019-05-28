//
//  CharViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/10.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController, RefreshChartsDelegate, switchShowIncomeOrCostChartDelegate{
    
    func refreshAnnualCharts() {
        lineChartsModel.countAnnualCostAmount(year: datePickerView.dateLabel.text!)
        lineChartsModel.countAnnualIncomeAmount(year: datePickerView.dateLabel.text!)
        lineChartsView.yCost = lineChartsModel.annualCostAmountArray
        lineChartsView.yIncome = lineChartsModel.annualIncomeAmountArray
        lineChartsView.addLineChart()
        lineChartsView.chartDescription()
        lineChartsView.interactionStyle()
        lineChartsView.setXAxisStyle()
        lineChartsView.setYAxisStyle()
        lineChartsView.updataData()
        tableView.reloadData()
    }
    
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
            tableView.reloadData()
        default:
            datePickerView.pickMode = .pickYear
            datePickerView.dateLabel.text = datePickerView.currentDate.toFormattedYearString()
            datePickerView.exchangeButton.isHidden = true
            noDataView.isHidden = true
            lineChartsModel.countAnnualCostAmount(year: datePickerView.dateLabel.text!)
            lineChartsModel.countAnnualIncomeAmount(year: datePickerView.dateLabel.text!)
            lineChartsView.yCost = lineChartsModel.annualCostAmountArray
            lineChartsView.yIncome = lineChartsModel.annualIncomeAmountArray
            lineChartsView.addLineChart()
            lineChartsView.chartDescription()
            lineChartsView.interactionStyle()
            lineChartsView.setXAxisStyle()
            lineChartsView.setYAxisStyle()
            lineChartsView.updataData()
            tableView.reloadData()        }
    }
    
    let datePickerView = gk_initViewFromNib(withType: DatePickerView.self)
    let tableView = UITableView()
    var pieChartsView = PieChartsView()
    let pieChartModel = PieChartsModel()
    let noDataView = UIView()
    var tableViewValues = [String:[Amount]]()
    let lineChartsView = LineChartsView()
    let lineChartsModel = LineChartsModel()
    var annualCostValues = [(key: String, values: [Amount?])]()
    var annualIncomeValues = [(key: String, values: [Amount?])]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewIfNeeded()
        tableView.register(UINib(nibName: "CategoryChartTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CategoryChartTableViewCell")
        tableView.register(UINib(nibName: "AnnualCostAndIncomeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "AnnualCostAndIncomeTableViewCell")
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
        if segmentedControl.selectedSegmentIndex == 0 {
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
        } else {
            refreshAnnualCharts()
        }
    }
}

extension ChartViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return tableViewValues.keys.count
        } else {
            return 12
           
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryChartTableViewCell") as! CategoryChartTableViewCell
            cell.configureCell(tableViewValues,indexPath: indexPath)
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnnualCostAndIncomeTableViewCell") as! AnnualCostAndIncomeTableViewCell
            annualIncomeValues = lineChartsModel.annualIncomeAmountArray.compactMap {$0}
            annualCostValues = lineChartsModel.annualCostAmountArray.compactMap {$0}
            cell.configureAnnualCostAndIncomeTableViewCell(annualIncomeValues , cost: annualCostValues, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath) as? AnnualCostAndIncomeTableViewCell
        guard let hidecell = cell else {
            return 44.0
        }
        if hidecell.isHidden {
                return 0.0
            } else {
                return 44.0
            }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if segmentedControl.selectedSegmentIndex == 0 {
            pieChartsView.backgroundColor = .white
            pieChartsView.frame.size = CGSize(width: 300, height: 300)
            pieChartsView.center = view.center
            return pieChartsView
        } else {
            lineChartsView.backgroundColor = .white
            lineChartsView.frame.size = CGSize(width: 300, height: 300)
            lineChartsView.center = view.center
            return lineChartsView
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
}
