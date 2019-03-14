//
//  ChecklistItem.swift
//  Checklists
//
//  Created by lpiem on 14/02/2019.
//  Copyright © 2019 lpiem. All rights reserved.
//

import Foundation
import  UserNotifications

class ChecklistItem : Codable, CustomStringConvertible {
    
    var text: String
    var checked: Bool
    var dueDate: Date
    var shouldRemind: Bool
    var itemID: Int
    
    init(text: String, checked: Bool = false, remind: Bool = false, date: Date = Date()) {
        self.text = text
        self.checked = checked
        self.dueDate = date
        self.shouldRemind = remind
        self.itemID = Preferences.shared().nextChecklistItemID()
    }
    
    init(text: String, checked: Bool = false, remind: Bool = false, date: Date = Date(), itemID: Int) {
        self.text = text
        self.checked = checked
        self.dueDate = date
        self.shouldRemind = remind
        self.itemID = itemID
    }
    
    func toggleChecked() {
        self.checked = !checked
    }

    var description: String {
        return self.text
    }
    
    func scheduleNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = text
        content.body = "Every Tuesday at 2pm"
        
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: dueDate)
        let month = calendar.component(.month, from: dueDate)
        let day = calendar.component(.day, from: dueDate)
        let hour = calendar.component(.hour, from: dueDate)
        let minutes = calendar.component(.minute, from: dueDate)
        let seconds = calendar.component(.second, from: dueDate)
        
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day  // Tuesday
        dateComponents.hour = hour    // 14:00 hours
        dateComponents.minute = minutes
        dateComponents.second = seconds
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: false)
        let uuidString = UUID().uuidString
        print(dateComponents)
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
            
        }
        
        center.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
    
}


