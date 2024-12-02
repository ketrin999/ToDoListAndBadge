//
//  Model.swift
//  ToDoList
//
//  Created by Ekaterina Yashunina on 19.11.2023.
//

import Foundation
import UserNotifications
import UIKit

var ToDoItems: [[String: Any]] {
    set {
        UserDefaults.standard.set(newValue, forKey: "ToDoDataKey")
        UserDefaults.standard.synchronize()
    }
    get {
        if let array = UserDefaults.standard.array(forKey: "ToDoDataKey") as? [[String: Any]] {
            return array
        } else {
            return []
        }
    }
}

func addItem(nameItem: String, isCompleted: Bool = false) {
    ToDoItems.append(["Name": nameItem, "isCompleted": isCompleted])
    setBadge()
}

func removeItem(at index: Int) {
    ToDoItems.remove(at: index)
    setBadge()
}

func moveItem(fromIndex: Int, toIndex: Int) {
    let from = ToDoItems[fromIndex]
    ToDoItems.remove(at: fromIndex)
    ToDoItems.insert(from, at: toIndex)
}

func changeState(at item: Int) -> Bool {
    ToDoItems[item]["isCompleted"] = !(ToDoItems[item]["isCompleted"] as! Bool)
    setBadge()
    return ToDoItems[item]["isCompleted"] as! Bool
}

func requestForNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.badge]) {(isEnablet, error) in
        if isEnablet {
            print("Согласие получено")
        } else {
            print("Пришел отказ")
        }
    }
}

func setBadge() {
    var totalBadgeNum = 0
    for item in ToDoItems {
        if item["isCompleted"] as? Bool == true {
            totalBadgeNum = totalBadgeNum + 1
        }
    }

    UNUserNotificationCenter.current().setBadgeCount(totalBadgeNum)
}
