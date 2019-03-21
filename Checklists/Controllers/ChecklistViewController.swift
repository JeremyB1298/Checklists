//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController{

    var list: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = list.name
    }
    
    //MARK: - prepare
    
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
            vc.itemToEdit = list.items?[id]
            vc.dueDate = (vc.itemToEdit?.dueDate)!
            vc.delegate = self
        }
    }
    //MARK: - data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = list.items else {
            return 0
        }
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",for: indexPath) as? ChecklistItemCell else {
            return UITableViewCell()
        }
        
        guard let list = list.items else {
            return UITableViewCell()
        }
        configureText(for: cell, withItem: list[indexPath.row])
        configureCheckmark(for: cell, withItem: list[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        list.items?[indexPath.row].deleteNotification()
        list.items?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        
    }
    
    //MARK: - table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let list = list.items else {
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
            cell.lblChecked.textColor = view.tintColor
        }
    }
    
    func configureText(for cell: ChecklistItemCell, withItem item: ChecklistItem) {
        cell.lblTitle.text = item.text
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        if item.shouldRemind, item.dueDate > Date() {
            item.scheduleNotification()
        } else {
            item.deleteNotification()
        }
        
        controller.dismiss(animated: true, completion: nil)
        
        list.items!.append(item)
        tableView.insertRows(at: [IndexPath(item: list.items!.count-1, section: 0)], with: UITableView.RowAnimation.top)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        if item.shouldRemind, item.dueDate > Date() {
            item.scheduleNotification()
        } else {
            item.deleteNotification()
        }
        guard let index = list.items!.firstIndex(where: { $0 === item }) else {
            return
        }
        list.items![index] = item
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: UITableView.RowAnimation.automatic)
    }
}

