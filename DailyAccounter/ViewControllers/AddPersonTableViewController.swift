//
//  AddPersonTableViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/1/3.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//


import UIKit
import RealmSwift

class AddPersonTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,GetMemberListDelegate{
    

    @IBOutlet weak var blurView: UIView!
    
    var tableView = UITableView(frame: .zero, style: .plain)
    var maskLayer = CAShapeLayer()
    var headerButtonView = UIView()
    
    @objc func dismissViewController() {
        blurView.alpha = 0
        dismiss(animated: true, completion: nil)
    }
    
    func getMemberList(arr: Results<Member>?) {
        if let arr = arr, arr.count != 0 {
            memberList = arr.toArray(ofType: Member.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.blurView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        blurView.alpha = 0
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        blurView.addGestureRecognizer(tapRecognizer)
        tableView.backgroundColor = .white
        headerButtonView.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memberList = (RealmService.shared.object(Member.self)?.toArray(ofType: Member.self)) ?? [Member]()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.frame = CGRect(x: 0, y: max(UIScreen.main.bounds.height / 3, UIScreen.main.bounds.height -  CGFloat(44*memberList.count)), width: UIScreen.main.bounds.width, height: min(UIScreen.main.bounds.height * 2 / 3, CGFloat(44*memberList.count)))
        self.view.addSubview(tableView)
        let frame = tableView.frame
        let editButton = UIButton(frame: CGRect(x:8, y: 8, width: 80, height: 50))
        editButton.setTitle("Edite", for: .normal)
        editButton.setTitleColor(UIColor.blue, for: .normal)
        
        editButton.addTarget(self, action: #selector(self.touchEditButton(_:)), for: .touchUpInside)
        
        let completeButton = UIButton(frame: CGRect(x:frame.width-95, y: 8, width: 80, height: 50))
        completeButton.setTitle("Complete", for: .normal)
        completeButton.setTitleColor(UIColor.blue, for: .normal)
        
        completeButton.addTarget(self, action: #selector(self.touchCompleteButton(_:)), for: .touchUpInside)
        
        let titleLabel = UILabel(frame: CGRect(x:frame.width/2-40, y: 8, width: 80, height: 50))
        titleLabel.text = "Members"
        
        headerButtonView.backgroundColor = UIColor.white
        headerButtonView.addSubview(editButton)
        headerButtonView.addSubview(titleLabel)
        headerButtonView.addSubview(completeButton)
        
        self.view.addSubview(headerButtonView)
        headerButtonView.translatesAutoresizingMaskIntoConstraints = false
        headerButtonView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerButtonView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        headerButtonView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerButtonView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear")
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        let cornerRadius: CGFloat = 10
        let maskLayer = CAShapeLayer()

        maskLayer.path = UIBezierPath(
            roundedRect: headerButtonView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
            ).cgPath

        headerButtonView.layer.mask = maskLayer
        
        headerButtonView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        headerButtonView.alpha = 0
        tableView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
        tableView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.headerButtonView.alpha = 1
            self.headerButtonView.transform = CGAffineTransform.identity
            self.tableView.alpha = 1
            self.tableView.transform = CGAffineTransform.identity
        }
    }
    
    var memberList = [Member]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectedItem: [String] = []
    
    lazy var selectedIndex = returnDefaultIndex(arr: memberList)
    
    func returnDefaultIndex(arr:[Member]) -> Int? {
        for idx in arr.indices {
            if arr[idx].isDefault == true {
                return idx
            }
        }
        return nil
    }
    
    @objc func touchEditButton(_ sender: UIButton) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManageMembersViewController") as! ManageMembersViewController
        let nav: UINavigationController = UINavigationController(rootViewController: controller)
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func touchCompleteButton(_ sender: UIButton) {
        dismissViewController()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        let member = memberList[indexPath.row]
        let setDefaultMemberViewController = SetDefaultMemberViewController()
        if member.isDefault == true {
            cell.textLabel?.attributedText = setDefaultMemberViewController.changeStringNSMutableAttributedString(text: member.memberName)
            cell.accessoryType = .checkmark
            cell.setSelected(true, animated: false)
        } else {
            cell.textLabel?.text = member.memberName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == selectedIndex {
            cell.setSelected(true, animated: false)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            if let memberName = memberList[indexPath.row].memberName, !(selectedItem.contains(memberName)) {
                selectedItem.append(memberName)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        guard let memberName = memberList[indexPath.row].memberName else { return }
        if cell?.accessoryType == .checkmark{
            cell?.accessoryType = .none
            if selectedItem.contains(memberName) {
                guard let indx = selectedItem.firstIndex(of: memberName) else { return }
                selectedItem.remove(at: indx)
            }
        } else {
            cell?.accessoryType = .checkmark
            if !selectedItem.contains(memberName) {
                selectedItem.append(memberName)
            }
        }
    }
}
