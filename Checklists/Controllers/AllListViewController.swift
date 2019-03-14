//
//  AllListViewController.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

class AllListViewController: UITableViewController {
    
    static var documentDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    static var dataFileUrl: URL {
        return AllListViewController.documentDirectory.appendingPathComponent("Checklist").appendingPathExtension("json")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(AllListViewController.dataFileUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "checklist") {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.topViewController as? ChecklistViewController else {
                return
            }
            guard let cell = sender as? UITableViewCell, let id = tableView.indexPath(for: cell)?.row else {
                return
            }
            
            vc.list = DataModel.shared().list![id]
            
        } else if (segue.identifier == "addList") {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.topViewController as? ListDetailViewController else {
                return
            }
            vc.delegate = self
        } else if (segue.identifier == "editList") {
            guard let nav = segue.destination as? UINavigationController, let vc = nav.topViewController as? ListDetailViewController else {
                return
            }
            
            guard let cell = sender as? UITableViewCell, let id = tableView.indexPath(for: cell)?.row else {
                return
            }
            vc.editList = DataModel.shared().list![id]
            vc.delegate = self
        }
    }
    
    //MARK: - data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.shared().list!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklists", for: indexPath)

        cell.textLabel?.text = DataModel.shared().list![indexPath.row].name
        
        switch (DataModel.shared().list![indexPath.row].items?.count,DataModel.shared().list![indexPath.row].uncheckedItemsCount) {
            
        case (0,_):
            cell.detailTextLabel?.text = "(No item)"
        case (_,0):
            cell.detailTextLabel?.text = "All Done!"
        case(_, let nbr):
            cell.detailTextLabel?.text = "\(nbr)"
        }
        
//        if DataModel.shared().list![indexPath.row].items?.count == 0 {
//            cell.detailTextLabel?.text = "(No item)"
//        } else if DataModel.shared().list![indexPath.row].uncheckedItemsCount == 0 {
//            cell.detailTextLabel?.text = "All Done!"
//        } else {
//            cell.detailTextLabel?.text = "\(DataModel.shared().list![indexPath.row].uncheckedItemsCount)"
//        }
        cell.imageView?.image = DataModel.shared().list![indexPath.row].icon?.image
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       DataModel.shared().list!.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}

extension AllListViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAddingItem list: Checklist) {
        controller.dismiss(animated: true, completion: nil)

        DataModel.shared().list!.append(list)
        DataModel.shared().list = DataModel.shared().sortCheklists(list: DataModel.shared().list!)
        
        tableView.insertRows(at: [IndexPath(item: DataModel.shared().list!.count-1, section: 0)], with: UITableView.RowAnimation.top)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditingItem list: Checklist) {
        controller.dismiss(animated: true, completion: nil)
        
        guard let index = DataModel.shared().list!.firstIndex(where: { $0 === list }) else {
            return
        }
        DataModel.shared().list![index] = list
        DataModel.shared().list = DataModel.shared().sortCheklists(list: DataModel.shared().list!)
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: UITableView.RowAnimation.automatic)
    }
    
    
}
