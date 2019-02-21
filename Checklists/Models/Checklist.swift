//
//  Checklist.swift
//  Checklists
//
//  Created by lpiem on 21/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation

class Checklist: Codable, CustomStringConvertible  {
    
    var name: String
    var items: [ChecklistItem]?
    
    var uncheckedItemsCount: Int {
        return (items?.filter({ $0.checked == false }).count)!
    }
    
    init(name: String,list: [ChecklistItem]? = []) {
        self.name = name
        guard let items = list else {
            return
        }
        self.items = items
    }
    var description: String {
        return self.name
    }
}
