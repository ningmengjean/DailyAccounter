//
//  ViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/6.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//

import UIKit
import RealmSwift


class MainViewController: UIViewController, DailyCostTableViewCellDelegate{
    
    func sendCostItemDetailToEdit() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let pvc = storyboard.instantiateViewController(withIdentifier: "AddCostOrIncomeDetailViewController") as! AddCostOrIncomeDetailViewController
//        guard let editIndexPath = editIndexPath else {
//            return
//        }
//        print(editIndexPath)
//        let editDetailAmount = dicByDaySorted[editIndexPath.section].value[editIndexPath.row - 1]
//        pvc.categoryLabel.text = editDetailAmount.category
//        pvc.categoryImageView.image = UIImage(named: editDetailAmount.category!)
//        pvc.digitLabel.text = String(editDetailAmount.amount)
//        pvc.detailText = editDetailAmount.detail
//        pvc.numberKeyboardUIView.dateButton.titleLabel?.text = editDetailAmount.date
//        pvc.segmentedControl.selectedSegmentIndex = 1
////        pvc.selectedPerson = editDetailAmount.persons
//        present(pvc, animated: true, completion: nil)
        print("kjdfljsof")
    }
    
  
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var amountResultsArr: [Amount]?
    var dicByDay = [String: [Amount]]()
    var dicByDaySorted = [(key: String, value: [Amount])]()
    var totalIncome: Float = 0.0
    var totalCost: Float = 0.0
    var isMonthPoint: Bool = false
    var month = [Int]()
    var monthArr = [Int]()
    var editIndexPath: IndexPath?
    
    func sortAmountResultsByDay(arr: [Amount]) {
        var dailyIncome: Float = 0.0
        var dailyCost: Float = 0.0
        for amount in arr {
            if dicByDay[amount.date!] == nil {
               dicByDay[amount.date!] = [amount]
                if amount.isCost == true {
                    dailyCost = amount.amount
                } else {
                    dailyIncome = amount.amount
                }
            } else {
                dicByDay[amount.date!]?.append(amount)
                if amount.isCost == true {
                    dailyCost += amount.amount
                } else {
                    dailyIncome += amount.amount
                }
            }
        }
        self.totalCost = dailyCost
        self.totalIncome = dailyIncome
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DailyIncomeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DailyIncomeTableViewCell")
        tableView.register(UINib(nibName: "DailyCostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DailyCostTableViewCell")
        tableView.register(UINib(nibName: "DailyBillSummaryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DailyBillSummaryTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 60.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        amountResultsArr = RealmService.shared.object(Amount.self)?.toArray(ofType: Amount.self)
        dicByDay = [String: [Amount]]()
        sortAmountResultsByDay(arr: amountResultsArr ?? [])
        dicByDaySorted = dicByDay.sorted(by:{ $0.0 > $1.0})
        month = returnMonthPoint()
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dicByDaySorted.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dicByDaySorted[section].1.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //section cell
        let sectionCell = tableView.dequeueReusableCell(withIdentifier: "DailyBillSummaryTableViewCell",for: indexPath) as! DailyBillSummaryTableViewCell
        if indexPath.row == 0 {
            sectionCell.CostLabel.text = "支出"
            sectionCell.dateLabel.text = String(dicByDaySorted[indexPath.section].key.suffix(2))+"日"
            sectionCell.IncomeLabel.text = "收入"
            let values = dicByDaySorted[indexPath.section].value
            let dailyIncome = values.filter { $0.isCost == false }.reduce(0.0) { $0 + $1.amount }
            let dailyCost = values.filter { $0.isCost == true }.reduce(0.0) { $0 + $1.amount }
            
            sectionCell.inAmount.text = String(format: "%.2f",dailyIncome)
            sectionCell.outAmount.text = String(format: "%.2f",dailyCost)
            return sectionCell
        }
        let costCell = tableView.dequeueReusableCell(withIdentifier: "DailyCostTableViewCell", for: indexPath) as! DailyCostTableViewCell
        let incomeCell = tableView.dequeueReusableCell(withIdentifier: "DailyIncomeTableViewCell",for: indexPath) as! DailyIncomeTableViewCell
        let detailAmount = dicByDaySorted[indexPath.section].value[indexPath.row - 1]
        if detailAmount.isCost == true {
            costCell.configureDailyCostTableViewCell(detailAmount: detailAmount)
            return costCell
        } else {
            incomeCell.configureDailyIncomeTableViewCell(detailAmount: detailAmount)
            return incomeCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let costCell = tableView.cellForRow(at: indexPath) as? DailyCostTableViewCell
        if costCell?.isShowEdit == false {
            costCell?.showDeleteAndEditButton()
            editIndexPath = indexPath
        } else {
            costCell?.hideDeleteAndEditButton()
            editIndexPath = nil
        }
        let incomeCell = tableView.cellForRow(at: indexPath) as? DailyIncomeTableViewCell
        if incomeCell?.isShowEdit == false {
            incomeCell?.showDeleteAndEditButton()
        } else {
            incomeCell?.hideDeleteAndEditButton()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let costCell = tableView.cellForRow(at: indexPath) as? DailyCostTableViewCell
        costCell?.hideDeleteAndEditButton()
        editIndexPath = nil
        let incomeCell = tableView.cellForRow(at: indexPath) as? DailyIncomeTableViewCell
        incomeCell?.hideDeleteAndEditButton()
    }
    
    func monthString(str: String) -> Int {
        let start = str.startIndex
        let end = str.index(str.endIndex, offsetBy: -3)
        let range = start..<end
        let mySubstring = String(str[range]).replacingOccurrences(of: "-", with: "")
        return Int(mySubstring)!
    }
    
    func returnMonthPoint() -> [Int] {
        for amount in dicByDaySorted {
            monthArr.append(monthString(str: amount.key))
        }
        let monthPoint = monthArr.orderedSet
        for mon in monthPoint {
            let index = monthArr.firstIndex(of: mon)
            month.append(index!)
        }
        return month
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        let monthPointView = UIView()
        monthPointView.backgroundColor = .white
        let lineView = UIView(frame: CGRect(x: frame.width/2-0.5, y: 0, width: 1, height: 60))
        lineView.backgroundColor = self.view.tintColor
        monthPointView.addSubview(lineView)
        let pointView = UIView(frame: CGRect(x: (frame.width/2-5), y: 22, width: 10, height: 10))
        let size:CGFloat = 10.0
        pointView.layer.cornerRadius = size/2
        pointView.backgroundColor = .gray
        monthPointView.addSubview(pointView)
        let monthLabel = UILabel(frame: CGRect(x: frame.width/2-40, y: 20, width: 30, height: 15))
        monthLabel.textColor = .lightGray
        monthLabel.adjustsFontSizeToFitWidth = true
        monthPointView.addSubview(monthLabel)
        let invisibleHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0))
        invisibleHeaderView.backgroundColor = .clear
        for point in month {
            if section == 0 {
                return invisibleHeaderView
            } else if section == point {
                monthLabel.text = String(monthArr[section]).suffix(2)+"月"
                return monthPointView
            }
        }
        return invisibleHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        for point in month {
            if section == 0 {
                return 0
            } else if section == point {
                return 60
            }
        }
        return 0
    }
}

