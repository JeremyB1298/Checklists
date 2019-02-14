//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        
        guard let list = checklistItem else {
            return
        }
        checklistItem?.append(item)
        tableView.insertRows(at: [IndexPath(item: list.count, section: 0)], with: UITableView.RowAnimation.top)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        controller.dismiss(animated: true, completion: nil)
        
        guard var list = checklistItem else {
            return
        }
        guard let index = checklistItem?.firstIndex(where: { $0 === item }) else {
            return
        }
        list[index] = item
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: UITableView.RowAnimation.automatic)
        saveChecklistItems()
    }
    
    var checklistItem: [ChecklistItem]?
    static var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static var dataFileUrl: URL {
        return ChecklistViewController.documentDirectory.appendingPathComponent("Checklists").appendingPathExtension("json")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(ChecklistViewController.documentDirectory)
        print(ChecklistViewController.dataFileUrl)
    }
    
    override func awakeFromNib() {
        loadChecklistItems()
    }
    
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
            vc.itemToEdit = checklistItem?[id]
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
        saveChecklistItems()
    }
    
    //MARK: - table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let list = checklistItem else {
            return
        }
        
        list[indexPath.row].toggleChecked()
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        saveChecklistItems()
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
    
    func saveChecklistItems() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(checklistItem)
            print(String(data: data, encoding: .utf8)!)
            try data.write(to: ChecklistViewController.dataFileUrl)
        } catch {
            //handle error
            print(error)
        }
    }
    
    func loadChecklistItems() {
        do {
        let datas = try Data(contentsOf: ChecklistViewController.dataFileUrl)
        
        let decoder = JSONDecoder()
        let list = try decoder.decode([ChecklistItem].self, from: datas)
        checklistItem = list
        }catch {
            //handle error
            print(error)
        }
    }
    
}

