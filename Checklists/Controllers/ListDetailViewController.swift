//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate : class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingItem list: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingItem list: Checklist)
}

class ListDetailViewController: UITableViewController {
    
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    var delegate: ListDetailViewControllerDelegate?
    
    var editList: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editList == nil {
            self.navigationItem.title = "Add List"
        } else {
            self.navigationItem.title = "Edit List"
            txtField.text = editList?.name
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtField.becomeFirstResponder()
        btnDone.isEnabled = false
    }
    
    // MARK: - Table view data source

    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    @IBAction func actDone() {
        if editList != nil{
            editList?.name = txtField.text!
            delegate?.listDetailViewController(self, didFinishEditingItem: editList!)
        } else {
            guard let txt = txtField.text else {
                return
            }
            delegate?.listDetailViewController(self, didFinishAddingItem: Checklist(name: txt))
        }
    }
}
extension ListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let nsString = txtField.text as NSString?
        let newString = nsString?.replacingCharacters(in: range, with: string)
        if newString?.isEmpty ?? true {
            btnDone.isEnabled = false
        } else {
            btnDone.isEnabled = true
        }
        return true
    }
}
