//
//  ViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/6.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, DailyCostTableViewCellDelegate,DailyIncomeTableViewCellDelegate {
 
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var incomeAmountLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthlyBackView: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var costAmountLabel: UILabel!
    @IBOutlet weak var monthlyDataView: UIView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToAddCostOrIncomeDetailViewController"{
            let pvc = segue.destination as! AddCostOrIncomeDetailViewController
            if let editCostIndexPath = editCostIndexPath {
                let editCostAmount = self.dicByDaySorted[editCostIndexPath.section].value[editCostIndexPath.row - 1]
                pvc.needToEditCostAmount = editCostAmount
            } else if let editIncomeIndexPath = editIncomeIndexPath {
                let editIncomeAmount = self.dicByDaySorted[editIncomeIndexPath.section].value[editIncomeIndexPath.row - 1]
                pvc.needToEditIncomeAmount = editIncomeAmount
            }
        }
    }
    
    func sendCostItemDetailToEdit(_ sender: UIButton) {
        month = []
        performSegue(withIdentifier: "pushToAddCostOrIncomeDetailViewController", sender: sender)
    }
    
    func sendIncomeItemDetailToEdit(_ sender: UIButton) {
        month = []
        performSegue(withIdentifier: "pushToAddCostOrIncomeDetailViewController", sender: sender)
    }
    
    func deleteCostItem(_ sender: UIButton) {
        guard let deleteCostItemIndexPath = deleteCostItemIndexPath else { return }
        let deleteCostItem = dicByDaySorted[deleteCostItemIndexPath.section].value[deleteCostItemIndexPath.row - 1]
        RealmService.shared.delete(deleteCostItem)
    }
    
    func deleteIncomeItem(_ sender: UIButton) {
        guard let deleteIncomeItemIndexPath = deleteIncomeItemIndexPath else { return }
        let deleteIncomeItem = dicByDaySorted[deleteIncomeItemIndexPath.section].value[deleteIncomeItemIndexPath.row - 1]
        RealmService.shared.delete(deleteIncomeItem)
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
    var month = [Int?]()
    var monthArr = [Int]()
    var editCostIndexPath: IndexPath?
    var editIncomeIndexPath: IndexPath?
    var deleteCostItemIndexPath: IndexPath?
    var deleteIncomeItemIndexPath: IndexPath?
    var notificationToken: NotificationToken? = nil
    var currentDate: String?
    let monthlyAmount = MonthlyAmount()
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
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
        loadViewIfNeeded()
        tableView.register(UINib(nibName: "DailyIncomeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DailyIncomeTableViewCell")
        tableView.register(UINib(nibName: "DailyCostTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DailyCostTableViewCell")
        tableView.register(UINib(nibName: "DailyBillSummaryTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DailyBillSummaryTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        self.tableView.sectionHeaderHeight = UITableView.automaticDimension
        self.tableView.estimatedSectionHeaderHeight = 60.0
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(pushToAddCostOrIncomeDetailViewController))
        
        let size:CGFloat = 60.0
        monthlyBackView?.layer.cornerRadius = size/2
        monthlyBackView?.backgroundColor = .lightGray
        monthLabel?.backgroundColor = UIColor.black.withAlphaComponent(0)
        monthlyDataView.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        let results = realm.objects(Amount.self)
        
        // Observe Results Notifications
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial,.update:
                // Query results have changed, so apply them to the UITableView
                self?.amountResultsArr = RealmService.shared.object(Amount.self)?.toArray(ofType: Amount.self)
                self?.dicByDay = [String: [Amount]]()
                self?.sortAmountResultsByDay(arr: self?.amountResultsArr ?? [])
                self?.dicByDaySorted = self?.dicByDay.sorted(by:{ $0.0 > $1.0}) ?? []
                self?.month = self?.returnMonthPoint() ?? []
                self?.currentDate = String(self?.dicByDaySorted.first?.value.first?.date?.dropLast(3) ?? "")
                tableView.reloadData()
                self?.scrollToFirstRow()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    @objc func pushToAddCostOrIncomeDetailViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "AddCostOrIncomeDetailViewController") as! AddCostOrIncomeDetailViewController
        pvc.needToEditCostAmount = nil
        month = []
        self.navigationController?.pushViewController(pvc, animated: true)
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
            costCell.delegate = self
            return costCell
        } else {
            incomeCell.configureDailyIncomeTableViewCell(detailAmount: detailAmount)
            incomeCell.delegate = self
            return incomeCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let costCell = tableView.cellForRow(at: indexPath) as? DailyCostTableViewCell
        if costCell?.isShowEdit == false {
            costCell?.showDeleteAndEditButton()
            editCostIndexPath = indexPath
            deleteCostItemIndexPath = indexPath
        } else {
            costCell?.hideDeleteAndEditButton()
            editCostIndexPath = nil
            deleteCostItemIndexPath = nil
        }
        let incomeCell = tableView.cellForRow(at: indexPath) as? DailyIncomeTableViewCell
        if incomeCell?.isShowEdit == false {
            incomeCell?.showDeleteAndEditButton()
            editIncomeIndexPath = indexPath
            deleteIncomeItemIndexPath = indexPath
        } else {
            incomeCell?.hideDeleteAndEditButton()
            editIncomeIndexPath = nil
            deleteIncomeItemIndexPath = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let costCell = tableView.cellForRow(at: indexPath) as? DailyCostTableViewCell
        costCell?.hideDeleteAndEditButton()
        editCostIndexPath = nil
        let incomeCell = tableView.cellForRow(at: indexPath) as? DailyIncomeTableViewCell
        incomeCell?.hideDeleteAndEditButton()
        editIncomeIndexPath = nil
    }
    
    func monthString(str: String) -> Int {
        let start = str.startIndex
        let end = str.index(str.endIndex, offsetBy: -3)
        let range = start..<end
        let mySubstring = String(str[range]).replacingOccurrences(of: "-", with: "")
        return Int(mySubstring)!
    }
    
    func returnMonthPoint() -> [Int?] {
        monthArr = []
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
                monthLabel.text = ""
                return monthPointView
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
                return 80
            } else if section == point {
                return 60
            }
        }
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else {return}
        let visibleSection = tableView.indexPathsForVisibleRows!.map{$0.section}.first

        if let visibleSection = visibleSection {
            let date = dicByDaySorted[visibleSection].key
            let start = date.startIndex
            let end = date.index(date.endIndex, offsetBy: -3)
            let range = start..<end
            let visibleDate = String(date[range])
            if visibleDate != currentDate {
                monthlyAmount.countMonthlyAmount(month: visibleDate)
                incomeLabel.text = String(visibleDate.suffix(2))+"月收入"
                incomeAmountLabel.text = String(monthlyAmount.monthlyIncome)
                monthLabel.text = String(visibleDate.suffix(2))+"月"
                costLabel.text = String(visibleDate.suffix(2))+"月支出"
                costAmountLabel.text = String(monthlyAmount.monthlyCost)
            } else {
                guard let currentDate = currentDate else { return }
                monthlyAmount.countMonthlyAmount(month: currentDate)
                incomeLabel.text = String(currentDate.suffix(2))+"月收入"
                incomeAmountLabel.text = String(monthlyAmount.monthlyIncome)
                monthLabel.text = String(currentDate.suffix(2))+"月"
                costLabel.text = String(currentDate.suffix(2))+"月支出"
                costAmountLabel.text = String(monthlyAmount.monthlyCost)
            }
        }
    }
}

