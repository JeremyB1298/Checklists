//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAddingItem item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        
        guard let list = checklistItem else {
            return
        }
        checklistItem?.append(item)
        tableView.insertRows(at: [IndexPath(item: list.count, section: 0)], with: UITableView.RowAnimation.top)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditingItem item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        
        guard var list = checklistItem else {
            return
        }
        guard let index = checklistItem?.firstIndex(where: { $0 === item }) else {
            return
        }
        list[index] = item
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: UITableView.RowAnimation.automatic)
    }
    
    var t: UITableViewController?
    var checklistItem: [ChecklistItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = ChecklistItem(text: "item")
        let item2 = ChecklistItem(text: "item",checked: true)
        let item3 = ChecklistItem(text: "item")
        let item4 = ChecklistItem(text: "item",checked:true)
        
        checklistItem = [item1, item2, item3, item4]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addItem") {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.viewControllers[0] as? AddItemViewController else {
                return
            }
            vc.navigationItem.title = "Add Item"
            vc.mode = false
            vc.delegate = self
        } else if (segue.identifier == "editItem") {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.viewControllers[0] as? AddItemViewController else {
                return
            }
            guard let cell = sender as? ChecklistItemCell, let id = tableView.indexPath(for: cell)?.row else {
                return
            }
            vc.navigationItem.title = "Edit Item"
            vc.itemToEdit = checklistItem?[id]
            vc.mode = true
            vc.delegate = self
        }
    }
    //MARK: - data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = checklistItem else {
            return 0
        }
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",for: indexPath) as? ChecklistItemCell else {
            return UITableViewCell()
        }
        
        guard let list = checklistItem else {
            return UITableViewCell()
        }
        configureText(for: cell, withItem: list[indexPath.row])
        configureCheckmark(for: cell, withItem: list[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklistItem?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    //MARK: - table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let list = checklistItem else {
            return
        }
        
        list[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    //MARK: - configuration
    
    func configureCheckmark(for cell: ChecklistItemCell, withItem item: ChecklistItem) {
        if item.checked == false {
            cell.lblChecked.isHidden = true
        } else {
            cell.lblChecked.isHidden = false
        }
    }
    
    func configureText(for cell: ChecklistItemCell, withItem item: ChecklistItem) {
        cell.lblTitle.text = item.text
    }
    
}

