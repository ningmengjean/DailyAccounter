//
//  SetDefaultMemberViewController.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/1/29.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import UIKit
import RealmSwift

class SetDefaultMemberViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    var memberArray = [Member]()
    var isDefault = false
    lazy var selectedIndex = returnDefaultIndex(arr: memberArray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(touchBackButton(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memberArray = (RealmService.shared.object(Member.self)?.toArray(ofType: Member.self)) ?? [Member]()
    }
    
    func returnDefaultIndex(arr:[Member]) -> Int? {
        for idx in arr.indices {
            if arr[idx].isDefault == true {
                return idx
            }
        }
        return nil
    }
    
    @objc func touchBackButton(_ sender: UINavigationItem)  {
        if self.isDefault {
            let oldMember = self.memberArray[self.selectedIndex!]
            RealmService.shared.update() {
                oldMember.isDefault = true
                return oldMember
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func changeStringNSMutableAttributedString(text: String?) -> NSMutableAttributedString? {
        let attributCellText = NSMutableAttributedString(string: text ?? "")
        let attributDefaultText = NSMutableAttributedString(string: "   (Default)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.blue])
        let combination = NSMutableAttributedString()
        combination.append(attributCellText)
        combination.append(attributDefaultText)
        return combination
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == selectedIndex {
            cell.setSelected(true, animated: false)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let member = memberArray[indexPath.row]
        if member.isDefault == true {
            cell.textLabel?.attributedText = changeStringNSMutableAttributedString(text: member.memberName)
            cell.selectionStyle = .none
            cell.accessoryType = .checkmark
            cell.setSelected(true, animated: false)
        } else {
            cell.textLabel?.text = member.memberName
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 8))
        view.backgroundColor = UIColor.lightGray
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let member = memberArray[indexPath.row]
        cell?.textLabel?.attributedText = changeStringNSMutableAttributedString(text: member.memberName)
        cell?.selectionStyle = .none
        cell?.accessoryType = .checkmark
        isDefault = true
        selectedIndex = indexPath.row
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let member = memberArray[indexPath.row]
        cell?.textLabel?.text = member.memberName
        cell?.accessoryType = .none
        isDefault = false
        let oldMember = self.memberArray[self.selectedIndex!]
        RealmService.shared.update() {
            oldMember.isDefault = false
            return oldMember
        }
    }
}
