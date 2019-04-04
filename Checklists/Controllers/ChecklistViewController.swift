//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController{

    var checkList: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = checkList.name
    }
    
    //MARK: - Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addItem") {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.topViewController as? ItemDetailViewController else {
                return
            }
            vc.navigationItem.title = "Add Item"
            vc.delegate = self
        } else if (segue.identifier == "editItem") {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.topViewController as? ItemDetailViewController else {
                return
            }
            guard let cell = sender as? ChecklistItemCell, let id = tableView.indexPath(for: cell)?.row else {
                return
            }
            vc.navigationItem.title = "Edit Item"
            vc.itemToEdit = checkList.items?[id]
            vc.dueDate = (vc.itemToEdit?.dueDate)!
            vc.delegate = self
        }
    }
    
    //MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = checkList.items else {
            return 0
        }
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",for: indexPath) as? ChecklistItemCell else {
            return UITableViewCell()
        }
        
        guard let list = checkList.items else {
            return UITableViewCell()
        }
        configureText(for: cell, withItem: list[indexPath.row])
        configureCheckmark(for: cell, withItem: list[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checkList.items?[indexPath.row].deleteNotification()
        checkList.items?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let list = checkList.items else {
            return
        }
        
        list[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
    }
    
    //MARK: - Configuration
    
    func configureCheckmark(for cell: ChecklistItemCell, withItem item: ChecklistItem) {
        if item.checked {
            cell.lblChecked.textColor = view.tintColor
        }
        cell.lblChecked.isHidden = !item.checked
    }
    
    func configureText(for cell: ChecklistItemCell, withItem item: ChecklistItem) {
        cell.lblTitle.text = item.text
    }
    
    //MARK: - Button action
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - ItemDetailViewControllerDelegate

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        
        controller.dismiss(animated: true, completion: nil)
        
        if item.shouldRemind, item.dueDate > Date() {
            item.scheduleNotification()
        } else {
            item.deleteNotification()
        }
        
        checkList.items!.append(item)
        tableView.insertRows(at: [IndexPath(item: checkList.items!.count-1, section: 0)], with: UITableView.RowAnimation.top)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        
        controller.dismiss(animated: true, completion: nil)
        
        if item.shouldRemind, item.dueDate > Date() {
            item.scheduleNotification()
        } else {
            item.deleteNotification()
        }
        guard let index = checkList.items!.firstIndex(where: { $0 === item }) else {
            return
        }
        checkList.items![index] = item
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: UITableView.RowAnimation.automatic)
    }
}

