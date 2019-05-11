//
//  DetailViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/3/30.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextFieldDelegate {
    
    var textField = UITextField()
    var textFieldFrameY = CGFloat()
    var detailText: String?
    var sendDetailText: ((String?) -> Void)?
    var blurView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.frame = self.view.bounds
        self.blurView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        blurView.alpha = 0
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        blurView.addGestureRecognizer(tapRecognizer)
        self.view.addSubview(blurView)
        self.textField.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-80, width: UIScreen.main.bounds.width, height: 80)
        textField.placeholder = "Detail:"
        textField.textAlignment = .left
        textField.backgroundColor = UIColor.white
        textField.delegate = self
        self.view.addSubview(textField)
    }
    
    @objc func dismissViewController() {
        textField.resignFirstResponder()
        if let sendDetailText = sendDetailText {
            detailText = textField.text
            sendDetailText(detailText)
        }
        blurView.alpha = 0
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        textField.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        upTextFieldWhenKeyboardShowed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeFromKeyboardNotification()
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
            self.textField.frame = CGRect(x: 0, y: ((self.view.bounds.height) - 80 - (self.textFieldFrameY)), width: self.view.bounds.width, height: 80)
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dismissViewController()
        return true;
    }
    
    @objc func keyboardWillDismiss() {
        UIView.animate(withDuration: 0.2, delay: 0, options:.transitionCurlUp ,animations: {
            self.view.layoutIfNeeded()
            self.textField.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-80, width: UIScreen.main.bounds.width, height: 80)
        })
    }
    
    func unSubscribeFromKeyboardNotification()  {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
