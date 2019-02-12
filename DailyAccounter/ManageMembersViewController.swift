//
//  ManageMembersViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2018/8/12.
//  Copyright © 2018年 Zhu xiaojin. All rights reserved.
//
protocol GetMemberListDelegate: class {
    func getMemberList(arr:[String]?)
}

import UIKit

class ManageMembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    var textField = UITextField()
    var memberArray = UserDefaults.standard.array(forKey: "Members") as?[String] ?? ["Me","Father","Mother"] {
        didSet {
            UserDefaults.standard.set(memberArray, forKey: "Members")
            tableview.reloadData()
        }
    }
    var textFieldFrameY = CGFloat()
    weak var delegate: GetMemberListDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        textField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.view.addSubview(textField)
    }
    
    @objc func touchMemberButton(_ sender: UINavigationItem)  {
        textField.resignFirstResponder()
       
        dismiss(animated: true, completion:{
            self.delegate?.getMemberList(arr: self.memberArray)
        })
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
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !memberArray.contains(text) {
            memberArray.append(text)
            textField.text = nil
        } else {
            AlertService.addAlert(in: self) {
                textField.text = nil 
            }
        }
        return true;
    }
    
    @objc func keyboardWillDismiss() {
        UIView.animate(withDuration: 0.2, delay: 0, options:.transitionCurlUp ,animations: {
            self.view.layoutIfNeeded()
            self.textField.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-60, width: UIScreen.main.bounds.width, height: 60)
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
        cell.textLabel?.text = memberArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            memberArray.remove(at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            UserDefaults.standard.set(memberArray, forKey:"Members")
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
			self?.memberArray.remove(at: index)
			self?.memberArray.insert(text, at: index)
			self?.tableview.reloadData()
		}
	}
}

