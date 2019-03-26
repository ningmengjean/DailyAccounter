//
//  EditMemberViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/1/17.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//


import UIKit

class EditMemberViewController: UIViewController,UITextFieldDelegate {
   
    @IBOutlet weak var textField: UITextField!
    var sendMemberBack: ((String, Int)-> Void)?	
	var currentIndex = 0
	var currentText = ""
    var initText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(touchBackButton(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Complete", style: .plain, target: self, action: #selector(touchCompleteButton(_:)))
		
        textField.delegate = self
		textField.text = currentText
        initText = currentText
        textField.becomeFirstResponder()
    }
    
    @objc func touchBackButton(_ sender: UINavigationItem) {
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }

    @objc func touchCompleteButton(_ sender: UINavigationItem) {
        textField.resignFirstResponder()
        if let text = self.textField.text, let sendMemberBack = self.sendMemberBack, !filterTextInRealmMemberArray(text) {
            sendMemberBack(text, self.currentIndex)
            dismiss(animated: true, completion: nil)
        } else {
            AlertService.addAlert(in: self, completion:{})
            textField.text = nil
        }
    }
    
    func filterTextInRealmMemberArray(_ text: String) -> Bool {
        guard let members = RealmService.shared.object(Member.self)?.toArray(ofType: Member.self) else { return false }
        for member in members {
            if member.memberName == text {
                return true
            }
        }
        return false
    }
}
