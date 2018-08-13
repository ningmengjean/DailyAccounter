//
//  AddCostOrIncomeDetailViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/8.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//

import UIKit

class AddCostOrIncomeDetailViewController: UIViewController {
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        incomeCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
    }

     var costCategory = ["Food","Lifestuff","Makeup","Babystuff","Clothes","Travel"]
     var incomeCategory = ["Salary","PinMoney","RedPocket","Alimony","Part-time","Investment","Bravo","Reimbursement","Cash","Refund","Others"]

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
}

extension AddCostOrIncomeDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 90.0, height: 96.0)
    }
}














