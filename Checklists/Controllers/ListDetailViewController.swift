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
    
    @IBOutlet weak var ivIcon: UIImageView!
    var delegate: ListDetailViewControllerDelegate?
    var icon: IconAsset?
    var editList: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editList == nil {
            self.navigationItem.title = "Add List"
            ivIcon.image = IconAsset.Folder.image
        } else {
            self.navigationItem.title = "Edit List"
            txtField.text = editList?.name
            ivIcon.image = editList?.icon?.image
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtField.becomeFirstResponder()
        if txtField.text?.count != 0 {
            btnDone.isEnabled = true
        } else {
            btnDone.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "IconSegueIdentifier") {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.topViewController as? IconPickerViewController else {
                return
            }
            vc.navigationItem.title = "Choose Icon"
            vc.delegate = self
        }
    }
    
    // MARK: - Table view data source

    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    @IBAction func actDone() {
        if editList != nil{
            editList?.name = txtField.text!
            editList?.icon = icon
            delegate?.listDetailViewController(self, didFinishEditingItem: editList!)
        } else {
            guard let txt = txtField.text else {
                return
            }
            if let checklistIcon = icon {
                delegate?.listDetailViewController(self, didFinishAddingItem: Checklist(name: txt, icon: checklistIcon))
            } else {
                delegate?.listDetailViewController(self, didFinishAddingItem: Checklist(name: txt))
            }
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

extension ListDetailViewController: IconPickerViewControllerDelegate {
    func iconPickerViewController(_ controller: IconPickerViewController, didFinishAddingIcon icon: IconAsset) {
        self.icon = icon
        ivIcon.image = icon.image
        controller.dismiss(animated: true, completion: nil)
    }

    func iconPickerViewControllerDidCancel(_ controller: IconPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
