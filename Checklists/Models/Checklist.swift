//
//  Checklist.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation

class Checklist: Codable, CustomStringConvertible  {
    
    var icon: IconAsset?
    var name: String
    var items: [ChecklistItem]?
    
    var uncheckedItemsCount: Int {
        return (items?.filter({ $0.checked == false }).count)!
    }
    
    init(name: String,list: [ChecklistItem]? = [], icon: IconAsset = .Folder) {
        self.icon = icon
        self.name = name
        guard let items = list else {
            return
        }
        self.items = items
    }
    var description: String {
        return self.name
    }
    
    func deleteNotifications() {
        for item in items! {
            item.deleteNotification()
        }
    }
    
}
