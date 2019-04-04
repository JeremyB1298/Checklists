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
    
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet var datePickerView: UITableViewCell!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemToEdit: ChecklistItem?
    
    var dueDate = Date()
    
    var isDatePickerVisible = false
    
    let datePickerViewIndexPath = IndexPath(row: 2, section: 1)
    
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
        btnDone.isEnabled = txtField.text?.count != 0 ? true : false
    }
    
    //MARK: - Personnal functions
    
    func showDatePicker() {
        isDatePickerVisible = true
        tableView.insertRows(at: [datePickerViewIndexPath], with: UITableView.RowAnimation.left)
        dueDateLabel.textColor = view.tintColor
        txtField.resignFirstResponder()
    }
    
    func hideDatePicker() {
        isDatePickerVisible = false
        tableView.deleteRows(at: [datePickerViewIndexPath], with: UITableView.RowAnimation.right)
        dueDateLabel.textColor = UIColor.lightGray
    }
    
    func updateDueDateLabel() -> String {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy, HH:mm"
        return dateFormatterPrint.string(from: dueDate)
        
    }
    
    //MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == datePickerViewIndexPath {
            return datePickerView
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1, isDatePickerVisible {
            return 3
        } else if section == 1 {
            return 2
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1, indexPath.section == 1 {
            isDatePickerVisible ? hideDatePicker() : showDatePicker()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == datePickerViewIndexPath {
            return datePicker.intrinsicContentSize.height + 1
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath == datePickerViewIndexPath {
            return 0
        } else {
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
    
    //MARK: - Button action
    
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

//MARK: - UITextFieldDelegate

extension ItemDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = txtField.text as NSString?
        guard var newString = nsString?.replacingCharacters(in: range, with: string) else {
            return false
        }
        newString = newString.trimmingCharacters(in: .whitespaces)
        btnDone.isEnabled = !newString.isEmpty
        return true
    }
}
