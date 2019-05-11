//
//  AddCostOrIncomeDetailViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/8.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//

import UIKit

class AddCostOrIncomeDetailViewController: UIViewController, NumberKeyboardUIViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
  
    @IBOutlet weak var digitLabel: UILabel!
    
    @IBOutlet weak var costCollectionView: UICollectionView! {
        didSet {
            costCollectionView.delegate = self
            costCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var incomeCollectionView: UICollectionView! {
        didSet {
            incomeCollectionView.delegate = self
            incomeCollectionView.dataSource = self
        }
    }
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            costCollectionView.isHidden = true
            incomeCollectionView.isHidden = false
        default:
            costCollectionView.isHidden = false
            incomeCollectionView.isHidden = true
        }
    }
    
    var detailText: String?
    var selectedPerson = [String]()
    var needToEditCostAmount: Amount?
    var needToEditIncomeAmount: Amount?
    
    func savePersonCost(arr: [String]?, cost: Float) {
        if arr?.count != 0 {
            for name in arr! {
                let person = PersonCost()
                person.name = name
                person.perPersonCost = cost/Float((arr!.count))
                RealmService.shared.saveObject(person)
            }
        }
    }
    
    let numberKeyboardUIView = gk_initViewFromNib(withType: NumberKeyboardUIView.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        incomeCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        numberKeyboardUIView.delegate = self
        numberKeyboardUIView.frame = CGRect(x: 0, y: self.view.bounds.height, width:self.view.bounds.width, height: 290)
        numberKeyboardUIView.backgroundColor = UIColor.lightGray
        numberKeyboardUIView.dateButton.setTitle(Amount.defaultDay(), for: .normal)
        self.view.insertSubview(numberKeyboardUIView, aboveSubview: incomeCollectionView)
        self.modalPresentationStyle = .currentContext
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(touchBackButton))
        if needToEditCostAmount != nil {
            categoryLabel.text = needToEditCostAmount!.category
            digitLabel.text = String(needToEditCostAmount!.amount)
            detailText = needToEditCostAmount!.detail
            numberKeyboardUIView.dateButton.setTitle(needToEditCostAmount?.date, for: .normal)
            categoryImageView.image = UIImage(named: needToEditCostAmount!.category ?? "食品")
            self.segmentedControl.selectedSegmentIndex = 1
            self.costCollectionView.isHidden = false
            self.incomeCollectionView.isHidden = true 
        } else if needToEditIncomeAmount != nil {
            categoryLabel.text = needToEditIncomeAmount!.category
            digitLabel.text = String(needToEditIncomeAmount!.amount)
            detailText = needToEditIncomeAmount!.detail
            numberKeyboardUIView.dateButton.setTitle(needToEditIncomeAmount?.date, for: .normal)
            categoryImageView.image = UIImage(named: needToEditIncomeAmount!.category ?? "食品")
            self.segmentedControl.selectedSegmentIndex = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNumberKeyboardUIView()
    }
    
    var costCategory = ["食品","生活费","彩妆","儿童用品","衣服","旅游"]
    var incomeCategory = ["工资","生活费","红包","零花钱","兼职","投资收入","奖金","报销","现金","退款","其它"]
    var peopleInTheMiddleOfTyping = false
    
    func showNumberKeyboardUIView() {
        UIView.animate(withDuration: 0.2, delay: 0, options:.transitionCurlUp ,animations: {
            self.view.layoutIfNeeded()
            self.numberKeyboardUIView.frame = CGRect(x: 0, y: self.view.bounds.height - 290, width: self.view.bounds.width, height: 290)
        },
            completion: nil)
    }
    
    func hideNumberKeyboardUIView() {
        UIView.animate(withDuration: 0.2, delay:0, options: .curveEaseOut,animations: {
            self.view.layoutIfNeeded()
            self.numberKeyboardUIView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: 290)
            }, completion: nil)
    }
    
    func changeDigitalLabelText(label: UILabel) {
        let textCurrentInDisplay = digitLabel.text!
        let digit = label.text!
        if textCurrentInDisplay.contains(".") {
            if digit == "." {
                return
            }
        }
        if textCurrentInDisplay == "0" {
            if digit == "0" {
                return
            }
        }
        if peopleInTheMiddleOfTyping {
            digitLabel.text = textCurrentInDisplay + digit
        } else if (digit == ".") && (peopleInTheMiddleOfTyping == false) {
            digitLabel.text = "0" + "."
            peopleInTheMiddleOfTyping = true
        } else {
            digitLabel.text = digit
            
        }
        peopleInTheMiddleOfTyping = true
    }
    
    func cleanDigitalLabelText() {
        digitLabel.text = "0"
        peopleInTheMiddleOfTyping = false
    }
    
    func deleteOneDigitalOnTheLabelText() {
        digitLabel.text = String(digitLabel.text!.dropLast())
        if digitLabel.text == "" {
            digitLabel.text = "0"
            peopleInTheMiddleOfTyping = false
        }
    }
    
    func presentPersonViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "AddPersonTableViewController") as! AddPersonTableViewController
        pvc.view.backgroundColor = UIColor.clear
        pvc.view.isOpaque = false
        pvc.modalPresentationStyle = .overCurrentContext
        selectedPerson = pvc.selectedItem
        
        self.present(pvc, animated: true, completion: {
            UIView.animate(withDuration: 0.25, animations: {
                pvc.blurView.alpha = 1
            }, completion: nil)
        })
    }
    
    func presentCalenderViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "CalenderViewController") as! CalenderViewController
        pvc.view.backgroundColor = UIColor.clear
        pvc.view.isOpaque = false
        pvc.modalPresentationStyle = .overCurrentContext
        
        pvc.sendSelectedDay = { [weak self] day in
            self?.numberKeyboardUIView.dateButton.titleLabel?.text = day
        }
        self.present(pvc, animated: true, completion: {
            UIView.animate(withDuration: 0.25, animations: {
                pvc.blurView.alpha = 1
            }, completion: nil)
        })
    }
    
    func presentDetailViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        pvc.view.backgroundColor = UIColor.clear
        pvc.view.isOpaque = false
        pvc.textField.text = detailText
        pvc.modalPresentationStyle = .overCurrentContext
        pvc.sendDetailText = { text in
            self.detailText = text
        }
        self.present(pvc, animated: true, completion: {
            UIView.animate(withDuration: 0.25, animations: {
                pvc.blurView.alpha = 1
            }, completion: nil)
        })
    }
    
    func touchConformButton() {
        if digitLabel.text == "0" {
            let alert = UIAlertController(
                title: "Amount can't be 0",
                message: nil,
                preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if needToEditCostAmount != nil || needToEditIncomeAmount != nil {
            if segmentedControl.selectedSegmentIndex == 0 {
                guard let changeIncome = needToEditCostAmount ?? needToEditIncomeAmount else { return }
                RealmService.shared.update() {
                    changeIncome.category = self.categoryLabel.text
                    changeIncome.date = self.numberKeyboardUIView.dateButton.titleLabel?.text
                    changeIncome.detail = self.detailText
                    changeIncome.amount = Float(self.digitLabel.text!)!
                    changeIncome.isCost = false
                    self.savePersonCost(arr: self.selectedPerson, cost: Float(self.digitLabel.text!)!)
                    let persons = RealmService.shared.object(PersonCost.self)?.toArray(ofType: PersonCost.self)
                    for person in persons! {
                        changeIncome.persons.append(person)
                    }
                    return changeIncome
                }
            } else {
                guard let changeCost = needToEditCostAmount ?? needToEditIncomeAmount else { return }
                RealmService.shared.update() {
                    changeCost.category = self.categoryLabel.text
                    changeCost.date = self.numberKeyboardUIView.dateButton.titleLabel?.text
                    changeCost.detail = self.detailText
                    changeCost.amount = Float(self.digitLabel.text!)!
                    changeCost.isCost = true
                    self.savePersonCost(arr: self.selectedPerson, cost: Float(self.digitLabel.text!)!)
                    let persons = RealmService.shared.object(PersonCost.self)?.toArray(ofType: PersonCost.self)
                    for person in persons! {
                        changeCost.persons.append(person)
                    }
                    return changeCost
                }
            }
        } else {
            if segmentedControl.selectedSegmentIndex == 0 {
                let newIncome = Amount()
                newIncome.category = categoryLabel.text
                newIncome.date = self.numberKeyboardUIView.dateButton.titleLabel?.text
                newIncome.detail = detailText
                newIncome.amount = Float(digitLabel.text!)!
                newIncome.isCost = false
                newIncome.id = newIncome.incrementID()
                savePersonCost(arr: selectedPerson, cost: Float(digitLabel.text!)!)
                let persons = RealmService.shared.object(PersonCost.self)?.toArray(ofType: PersonCost.self)
                for person in persons! {
                    newIncome.persons.append(person)
                }
                RealmService.shared.saveObject(newIncome)
            } else {
                let newCost = Amount()
                newCost.category = categoryLabel.text
                newCost.date = self.numberKeyboardUIView.dateButton.titleLabel?.text
                newCost.detail = detailText
                newCost.amount = Float(digitLabel.text!)!
                newCost.isCost = true
                newCost.id = newCost.incrementID()
                savePersonCost(arr: selectedPerson, cost: Float(digitLabel.text!)!)
                let persons = RealmService.shared.object(PersonCost.self)?.toArray(ofType: PersonCost.self)
                for person in persons! {
                    newCost.persons.append(person)
                }
                RealmService.shared.saveObject(newCost)
            }
        }
         navigationController?.popViewController(animated: true)
    }
    
    @objc func touchBackButton() {
        needToEditCostAmount = nil
        needToEditIncomeAmount = nil
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddCostOrIncomeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == costCollectionView {
            return costCategory.count
        } else {
            return incomeCategory.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        if collectionView == costCollectionView {
            categoryCell.categoryLabel.text = costCategory[indexPath.row]
            categoryCell.categoryImageView.image = UIImage(named: costCategory[indexPath.row])
            return categoryCell
        } else {
            categoryCell.categoryLabel.text = incomeCategory[indexPath.row]
            categoryCell.categoryImageView.image = UIImage(named: incomeCategory[indexPath.row])
            return categoryCell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        guard let text = cell.categoryLabel.text, let image = cell.categoryImageView.image else {
            return
        }
        categoryLabel.text = text
        categoryImageView.image = image
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === incomeCollectionView || scrollView === costCollectionView {
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if translation.y > 0{
                hideNumberKeyboardUIView()
            } else {
                showNumberKeyboardUIView()
            }
        }
    }
}

extension AddCostOrIncomeDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: UIScreen.main.bounds.width/5, height: 80)
    }
}

















