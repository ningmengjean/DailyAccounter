//
//  DailyIncomeTableViewCell.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/4/6.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

protocol DailyIncomeTableViewCellDelegate: class {
    func sendIncomeItemDetailToEdit(_ sender: UIButton)
    func deleteIncomeItem(_ sender: UIButton)
}

class DailyIncomeTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var inCategory: UILabel!
    @IBOutlet weak var inAmount: UILabel!
    @IBOutlet weak var inDetail: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func toAddCostOrIncomeViewController(_ sender: UIButton) {
        delegate?.sendIncomeItemDetailToEdit(sender)
        hideDeleteAndEditButton()
    }
    @IBAction func deleteIncomeItem(_ sender: UIButton) {
        delegate?.deleteIncomeItem(sender)
    }
    
    var isShowEdit = false
    weak var delegate: DailyIncomeTableViewCellDelegate?

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
    
    func configureDailyIncomeTableViewCell(detailAmount: Amount) {
        categoryImageView.image = UIImage(named: detailAmount.category ?? "工资")
        inAmount.text = String(format: "%.2f",detailAmount.amount)
        inCategory.text = detailAmount.category ?? "工资"
        inDetail.text = detailAmount.detail
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
