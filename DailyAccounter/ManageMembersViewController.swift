//
//  ManageMembersViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/12.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//
protocol GetMemberListDelegate: class {
    func getMemberList(arr:Results<Member>?)
}

import UIKit
import RealmSwift

class ManageMembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var tableView = UITableView(frame: .zero, style: .plain)
    var textField = UITextField()

    var memberArray = [Member]() {
        didSet{
            tableView.reloadData()
        }
    }
    var textFieldFrameY = CGFloat()
    weak var delegate: GetMemberListDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        textField.becomeFirstResponder()
        memberArray = RealmService.shared.object(Member.self)!.toArray(ofType: Member.self)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        upTextFieldWhenKeyboardShowed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeFromKeyboardNotification()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Member", style: .plain, target: self, action: #selector(touchMemberButton(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Default", style: .plain, target: self, action: #selector(touchDefaultButton(_:)))
        self.textField.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-60, width: UIScreen.main.bounds.width, height: 60)
        textField.placeholder = "Add Memebers"
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.lightGray
        textField.delegate = self
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height:(UIScreen.main.bounds.height - 60))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        self.view.addSubview(tableView)
        self.view.addSubview(textField)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.sectionFooterHeight = 0.1
    }
    
    @objc func touchMemberButton(_ sender: UINavigationItem)  {
        textField.resignFirstResponder()
        let memberResults = RealmService.shared.object(Member.self)
        self.delegate?.getMemberList(arr: memberResults)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func touchDefaultButton(_ sender: UINavigationItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SetDefaultMemberViewController") as! SetDefaultMemberViewController
        controller.memberArray = memberArray
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
         textFieldFrameY = getKeyboardHeight(notification)
         upTextFieldWhenKeyboardShowed()
    }

    func upTextFieldWhenKeyboardShowed() {
        UIView.animate(withDuration: 0.2, delay: 0, options:.transitionCurlUp ,animations: {
            self.view.layoutIfNeeded()
            self.textField.frame = CGRect(x: 0, y: ((self.view.bounds.height) - 60 - (self.textFieldFrameY)), width: self.view.bounds.width, height: 60)
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (UIScreen.main.bounds.height - 60 - self.textFieldFrameY))
            let numberOfRows = self.tableView.numberOfRows(inSection: 0)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: true)
            }
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text,  !filterTextInRealmMemberArray(text){
            
            let newMember = Member()
            newMember.id = newMember.incrementID()
            newMember.memberName = text

            memberArray.append(newMember)
            RealmService.shared.saveObject(newMember)
            textField.text = nil
        } else {
            AlertService.addAlert(in: self) {
                textField.text = nil 
            }
        }
        return true;
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
    
    @objc func keyboardWillDismiss() {
        UIView.animate(withDuration: 0.2, delay: 0, options:.transitionCurlUp ,animations: {
            self.view.layoutIfNeeded()
            self.textField.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-60, width: UIScreen.main.bounds.width, height: 60)
            self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: (UIScreen.main.bounds.height - 60))
        }, completion: nil)
    }
    
    func unSubscribeFromKeyboardNotification()  {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let member = memberArray[indexPath.row]
        let setDefaultMemberViewController = SetDefaultMemberViewController()
        if member.isDefault == true {
            cell.textLabel?.attributedText = setDefaultMemberViewController.changeStringNSMutableAttributedString(text: member.memberName)
            cell.selectionStyle = .none
            cell.accessoryType = .checkmark
            cell.setSelected(true, animated: false)
        } else {
            cell.textLabel?.text = member.memberName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let member = memberArray[indexPath.row]
           
            memberArray.remove(at: indexPath.row)
            RealmService.shared.delete(member)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "EditMemberViewController") as! EditMemberViewController
		
		let nav: UINavigationController = UINavigationController(rootViewController: controller)
		guard let text = cell?.textLabel?.text else { return }
		controller.currentIndex = indexPath.row
		controller.currentText = text
		self.present(nav, animated: true, completion: nil)
		controller.sendMemberBack = { [weak self] text, index in
            if self?.filterTextInRealmMemberArray(text) == true {
                AlertService.addAlert(in: controller.self){ }
                
            } else {
                guard let oldMember = self?.memberArray[index] else { return }
                RealmService.shared.update() {
                    oldMember.memberName = text
                    oldMember.isDefault = false
                    return oldMember
                }
            }
		}
	}
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView()
//        footerView.frame = CGRect(x: 0, y: ((self.view.bounds.height) - 60 - (self.textFieldFrameY+0.1)), width: self.view.bounds.width, height: 0.1)
//        return footerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.1
//    }
}

