//
//  AddPersonTableViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/1/3.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//


import UIKit
import RealmSwift

class AddPersonTableViewController: UITableViewController,GetMemberListDelegate{
    func getMemberList(arr: [String]?) {
        if let arr = arr, arr.count != 0 {
            memberList = arr
            UserDefaults.standard.set(memberList, forKey: "Members")
        } else {
            memberList = []
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    var memberList = UserDefaults.standard.stringArray(forKey: "Members") ?? ["Me","Father","Mother"]{
        didSet {
            UserDefaults.standard.set(memberList, forKey: "Members")
            tableView.reloadData()
        }
    }

    @objc func touchEditButton(_ sender: UIButton) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManageMembersViewController") as! ManageMembersViewController
        let nav: UINavigationController = UINavigationController(rootViewController: controller)
        controller.delegate = self
        self.present(nav, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberList.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = tableView.frame
        
        let editButton = UIButton(frame: CGRect(x:8, y: 8, width: 80, height: 50))
        editButton.setTitle("Edite", for: .normal)
        editButton.setTitleColor(UIColor.blue, for: .normal)
        editButton.addTarget(self, action: #selector(self.touchEditButton(_:)), for: .touchUpInside)

        let completeButton = UIButton(frame: CGRect(x:frame.width-95, y: 8, width: 80, height: 50))
        completeButton.setTitle("Complete", for: .normal)
        completeButton.setTitleColor(UIColor.blue, for: .normal)
        
        let titleLabel = UILabel(frame: CGRect(x:frame.width/2-40, y: 8, width: 80, height: 50))
        titleLabel.text = "Members"
        
        let headerView = UIView(frame: CGRect(x:0, y:0, width:frame.size.width, height:frame.size.height))
        headerView.addSubview(editButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(completeButton)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = memberList[indexPath.row]
        return cell
    }
}
