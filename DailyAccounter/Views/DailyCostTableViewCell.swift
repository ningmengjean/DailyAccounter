//
//  DailyCostTableViewCell.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/4/2.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

protocol DailyCostTableViewCellDelegate: class {
    func sendCostItemDetailToEdit(_ sender: UIButton)
    func deleteCostItem(_ sender: UIButton)
}

class DailyCostTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var outCategoryLabel: UILabel!
    @IBOutlet weak var outAmountLabel: UILabel!
    @IBOutlet weak var outDetailLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBAction func toAddCostOrIncomeViewController(_ sender: UIButton) {
        delegate?.sendCostItemDetailToEdit(sender)
        hideDeleteAndEditButton()
    }
    
    @IBAction func deleteCostItem(_ sender: UIButton) {
        delegate?.deleteCostItem(sender)
    }
    
    var isShowEdit = false
    weak var delegate: DailyCostTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.deleteButton.isHidden = true
        self.editButton.isHidden = true
        deleteButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        editButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    func configureDailyCostTableViewCell(detailAmount: Amount) {
        categoryImageView.image = UIImage(named:detailAmount.category ?? "食品")
        outAmountLabel.text = String(format: "%.2f",detailAmount.amount)
        outCategoryLabel.text = detailAmount.category ?? "食品`"
        outDetailLabel.text = detailAmount.detail 
    }
    
    func showDeleteAndEditButton() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.deleteButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.deleteButton.isHidden = false
                        self.editButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.editButton.isHidden = false
                        self.isShowEdit = true
        })
    }
    
    func hideDeleteAndEditButton() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        self.deleteButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        self.deleteButton.isHidden = true
                        self.editButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                        self.editButton.isHidden = true
                        self.isShowEdit = false
        })
    }
}
