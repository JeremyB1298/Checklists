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
            print(String(data: data, encoding: .utf8)!)
            try data.write(to: AllListViewController.dataFileUrl)
        } catch {
            print(error)
        }
    }
    
    class func shared() -> DataModel {
        return sharedNetworkManager
    }
    
    private func loadChecklist() -> [Checklist] {
        if !FileManager.default.fileExists(atPath: AllListViewController.dataFileUrl.path) {
            return []
        }else {
            do {
                let datas = try Data(contentsOf: AllListViewController.dataFileUrl)
                
                let decoder = JSONDecoder()
                let list = try decoder.decode([Checklist].self, from: datas)
                return list
            }catch {
                print(error)
            }
        }
        return []
    }
}
