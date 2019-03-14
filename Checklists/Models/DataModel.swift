//
//  DataModel.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import UIKit

class DataModel {
    
    var list: [Checklist]?
    
    private static var sharedNetworkManager: DataModel = {
        UserDefaults.standard.register(defaults: [UserDefaultsKeys.firstLaunch: true])
        UserDefaults.standard.register(defaults: [UserDefaultsKeys.checklistItemID: 0])
        let dataModel = DataModel()
        return dataModel
    }()
    
    private init() {
        list = loadChecklist()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(saveChecklists),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
    }
    
     @objc func saveChecklists() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self.list)
            //print(String(data: data, encoding: .utf8)!)
            try data.write(to: AllListViewController.dataFileUrl)
        } catch {
            print(error)
        }
    }
    
    class func shared() -> DataModel {
        return sharedNetworkManager
    }
    
    private func loadChecklist() -> [Checklist] {
        
        if(Preferences.firstLaunch) {
            let list = [Checklist(name: "List", list: [ChecklistItem(text: "Edit your first item"), ChecklistItem(text: "Swipe me to delete")], icon: IconAsset.Folder)]
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.firstLaunch)
            return list
        }
        
        if !FileManager.default.fileExists(atPath: AllListViewController.dataFileUrl.path) {
            return []
        }else {
            do {
                let datas = try Data(contentsOf: AllListViewController.dataFileUrl)
                
                let decoder = JSONDecoder()
                let list = try decoder.decode([Checklist].self, from: datas)
                    return sortCheklists(list: list)
            }catch {
                print(error)
            }
        }
        return []
    }
    
    func sortCheklists(list: [Checklist]) -> [Checklist] {
        if list.count >= 2 {
            return list.sorted(by: { $0.name < $1.name })
        }else {
            return list
        }
    }
}
