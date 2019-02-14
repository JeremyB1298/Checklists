//
//  AddItemViewConrtoller.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit

protocol AddItemViewControllerDelegate : class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem)
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: ChecklistItem)
}

class AddItemViewController: UITableViewController {
    
    var delegate: AddItemViewControllerDelegate?
    
    @IBOutlet weak var bDone: UIBarButtonItem!
    
    @IBOutlet weak var txtField: UITextField!
    
    var itemToEdit: ChecklistItem?
    
    var mode: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == true {
            print("mode edit")
            print(itemToEdit?.text)
        } else {
            print("add mode")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtField.becomeFirstResponder()
        bDone.isEnabled = false
        
    }
    
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if mode == true {
            guard let txt = txtField.text, let item = itemToEdit else {
                return
            }
            item.text = txt
            delegate?.addItemViewController(self, didFinishEditingItem: item)
        } else {
            guard let txt = txtField.text else {
                return
            }
            delegate?.addItemViewController(self, didFinishAddingItem: ChecklistItem(text: txt, checked: false))
        }
    }
    
    
}
extension AddItemViewController: UITextFieldDelegate {
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
