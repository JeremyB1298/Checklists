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
    
    var itemToEdit: ChecklistItem?
    
    var mode: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemToEdit != nil {
            txtField.text = itemToEdit?.text
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtField.becomeFirstResponder()
        bDone.isEnabled = false
        
    }
    
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        if itemToEdit != nil{
            itemToEdit?.text = txtField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: itemToEdit!)
        } else {
            guard let txt = txtField.text else {
                return
            }
            delegate?.itemDetailViewController(self, didFinishAddingItem: ChecklistItem(text: txt, checked: false))
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
