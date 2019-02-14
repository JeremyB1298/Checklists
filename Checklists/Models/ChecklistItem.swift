//
//  ChecklistItem.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation

class ChecklistItem {
    
    var text: String?
    var checked: Bool?
    
    init(text: String,checked: Bool = false ) {
        self.text = text
        self.checked = checked
    }
    
    func toggleChecked() {
        guard let checked = self.checked else {
            return
        }
        self.checked = !checked
    }
    
}
