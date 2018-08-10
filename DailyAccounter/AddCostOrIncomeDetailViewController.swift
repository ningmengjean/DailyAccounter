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
    
    @IBOutlet weak var categorymageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            collectionView.isHidden = false
        default:
            collectionView.isHidden = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        
    }

     var category = ["Food","Lifestuff","Makeup","Babystuff","Clothes","Travel","More"]

}

extension AddCostOrIncomeDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        categoryCell.categoryLabel.text = category[indexPath.row]
        categoryCell.categoryImageView.image = UIImage(named: category[indexPath.row])
        return categoryCell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        guard let text = cell.categoryLabel.text, let image = cell.categoryImageView.image else {
            return
        }
        categoryLabel.text = text
        categorymageView.image = image
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












