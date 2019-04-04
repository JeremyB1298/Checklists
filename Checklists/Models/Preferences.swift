//
//  Preferences.swift
//  Checklists
//
//  Created by lpiem on 14/03/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation

class Preferences {
    
    static var firstLaunch: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.firstLaunch)
    }
    
    private static var sharedNetworkManager: Preferences = {
        let preferences = Preferences()
        return preferences
    }()
    
    class func shared() -> Preferences {
        return sharedNetworkManager
    }
    
    func nextChecklistItemID() -> Int {
        let newId = UserDefaults.standard.integer(forKey: UserDefaultsKeys.checklistItemID) + 1
        UserDefaults.standard.set(newId, forKey: UserDefaultsKeys.checklistItemID)
        return newId
    }
    
}
