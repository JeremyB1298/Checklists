//
//  ItemDetailViewConrtoller.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate : class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
    
    var delegate: ItemDetailViewControllerDelegate?
    
    @IBOutlet weak var bDone: UIBarButtonItem!
    
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet var datePickerView: UITableViewCell!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var itemToEdit: ChecklistItem?
    
    var dueDate = Date()
    
    var mode: Bool?
    
    var isDatePickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemToEdit != nil {
            txtField.text = itemToEdit?.text
            datePicker.date = (itemToEdit?.dueDate)!
            shouldRemindSwitch.isOn = (itemToEdit?.shouldRemind)!
        }
            dueDateLabel.text = updateDueDateLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtField.becomeFirstResponder()
        if txtField.text?.count != 0 {
            bDone.isEnabled = true
        } else {
            bDone.isEnabled = false
        }
    }
    
    func showDatePicker() {
        isDatePickerVisible = true
        tableView.insertRows(at: [IndexPath(row: 2, section: 1)], with: UITableView.RowAnimation.left)
        tableView.reloadData()
        dueDateLabel.textColor = view.tintColor
    }
    
    func hideDatePicker() {
        isDatePickerVisible = false
        tableView.deleteRows(at: [IndexPath(row: 2, section: 1)], with: UITableView.RowAnimation.right)
        tableView.reloadData()
        dueDateLabel.textColor = UIColor.lightGray
    }
    
    func updateDueDateLabel() -> String {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy, HH:mm"
        print(dueDate.description)
        return dateFormatterPrint.string(from: dueDate)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == IndexPath(row: 2, section: 1) {
            return datePickerView
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 1, indexPath.section == 1 {
            return indexPath
        }
        return super.tableView(tableView, willSelectRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1, isDatePickerVisible {
            return 3
        } else if section == 1 {
            return 2
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2, indexPath.section == 1 {
            return datePicker.intrinsicContentSize.height + 1
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1, indexPath.section == 1 {
            if isDatePickerVisible {
                hideDatePicker()
            } else {
                showDatePicker()
            }
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.row == 2, indexPath.section == 1 {
            return 0
        } else {
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if itemToEdit != nil{
            itemToEdit?.text = txtField.text!
            itemToEdit?.shouldRemind = shouldRemindSwitch.isOn
            itemToEdit?.dueDate = dueDate
            delegate?.itemDetailViewController(self, didFinishEditingItem: itemToEdit!)
        } else {
            guard let txt = txtField.text else {
                return
            }
            delegate?.itemDetailViewController(self, didFinishAddingItem: ChecklistItem(text: txt, checked: false,remind: shouldRemindSwitch.isOn, date: dueDate))
        }
        
    }
    
    @IBAction func dateChanged(_ sender: Any) {
        dueDate = datePicker.date
        dueDateLabel.text = updateDueDateLabel()
    }
    
    @IBAction func txtFieldBegin(_ sender: Any) {
        if isDatePickerVisible {
            hideDatePicker()
        }
    }
    
}
extension ItemDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = txtField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        if newString?.isEmpty ?? true {
            bDone.isEnabled = false
        } else {
            bDone.isEnabled = true
        }
        return true
    }
}
