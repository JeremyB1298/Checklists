//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate : class {
    func iconPickerViewControllerDidCancel(_ controller: IconPickerViewController)
    func iconPickerViewController(_ controller: IconPickerViewController, didFinishAddingIcon icon: IconAsset)
}

class IconPickerViewController: UITableViewController {
    var delegate : IconPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TSable view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IconAsset.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IconlistItem",for: indexPath) as? IconTableViewCell else {
            return UITableViewCell()
        }
        
        cell.imageView?.image = IconAsset.allCases[indexPath.row].image
        cell.lblTitle.text = IconAsset.allCases[indexPath.row].rawValue
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.iconPickerViewController(self, didFinishAddingIcon: IconAsset.allCases[indexPath.row])
    }

    // MARK: - Personnal functions
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.iconPickerViewControllerDidCancel(self)
    }
}
