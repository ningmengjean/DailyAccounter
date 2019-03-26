//
//  AddCostOrIncomeDetailViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/8.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//

import UIKit

class AddCostOrIncomeDetailViewController: UIViewController, NumberKeyboardUIViewDelegate,UIViewControllerTransitioningDelegate {
    
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
    
    let numberKeyboardUIView = gk_initViewFromNib(withType: NumberKeyboardUIView.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        incomeCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        numberKeyboardUIView.delegate = self
        numberKeyboardUIView.frame = CGRect(x: 0, y: self.view.bounds.height, width:self.view.bounds.width, height: 290)
        numberKeyboardUIView.backgroundColor = UIColor.lightGray
        self.view.insertSubview(numberKeyboardUIView, aboveSubview: incomeCollectionView)
        self.modalPresentationStyle = .currentContext
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNumberKeyboardUIView()
    }

     var costCategory = ["Food","Lifestuff","Makeup","Babystuff","Clothes","Travel"]
     var incomeCategory = ["Salary","PinMoney","RedPocket","Alimony","Part-time","Investment","Bravo","Reimbursement","Cash","Refund","Others"]
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
    
//    func presentPersonViewController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let pvc = storyboard.instantiateViewController(withIdentifier: "AddPersonTableViewController") as! UITableViewController
//
//        pvc.modalPresentationStyle = UIModalPresentationStyle.custom
//        pvc.transitioningDelegate = self
//        pvc.view.backgroundColor = UIColor.white
//
//        self.present(pvc, animated: true, completion: nil)
//    }
//
//    func presentationController(forPresented presented: UIViewController,
//                                presenting: UIViewController?,
//                                source: UIViewController) -> UIPresentationController? {
//        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
//    }
    
    func presentPersonViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvc = storyboard.instantiateViewController(withIdentifier: "AddPersonTableViewController")
        pvc.view.backgroundColor = UIColor.clear
        pvc.view.isOpaque = false
        pvc.modalPresentationStyle = .overCurrentContext

        self.present(pvc, animated: true, completion: nil)
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

        return CGSize(width: 90.0, height: 96.0)
    }
}

















