//
//  NumberKeyboardUIView.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/13.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//

public func gk_initViewFromNib<T: UIView>(withType type: T.Type) -> T {
    return (Bundle.main.loadNibNamed(String(describing: type.self), owner: nil, options: nil)!.first as? T)!
}

protocol NumberKeyboardUIViewDelegate: class {
    func changeDigitalLabelText(label: UILabel)
    func cleanDigitalLabelText()
    func deleteOneDigitalOnTheLabelText()
    func presentPersonViewController()
    func presentCalenderViewController()
    func presentDetailViewController()
    func touchConformButton()
}

import UIKit

class NumberKeyboardUIView: UIView {
    
    @IBOutlet weak var dateButton: UIButton! {
        didSet {
            dateButton.setTitle(Amount.defaultDay(), for: .normal) 
        }
    }
    @IBOutlet weak var personButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    @IBAction func presentCalenderViewController(_ sender: UIButton) {
        delegate?.presentCalenderViewController()
    }
    
    @IBAction func presentPersonViewController(_ sender: UIButton) {
        delegate?.presentPersonViewController()
    }
    
    @IBAction func presentDetailViewController(_ sender: UIButton) {
        delegate?.presentDetailViewController()
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if let digit = sender.titleLabel {
            delegate?.changeDigitalLabelText(label: digit)
        }
    }
    
    @IBAction func touchDelete(_ sender: UIButton) {
        delegate?.deleteOneDigitalOnTheLabelText()
    }
    
    @IBAction func touchConform(_ sender: UIButton) {
       
        delegate?.touchConformButton()
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        delegate?.cleanDigitalLabelText()
    }
    
    var delegate: NumberKeyboardUIViewDelegate?
}
