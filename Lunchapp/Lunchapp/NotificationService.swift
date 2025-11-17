//
//  NotificationService.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 12/11/25.
//

import Foundation
import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let err = error { print("Notification auth error: \(err)") }
            print("Notifications allowed: \(granted)")
        }
    }

    func scheduleReminder(for item: GroceryItem, listTitle: String) {
        guard let date = item.reminderDate else { return }
        let content = UNMutableNotificationContent()
        content.title = "Buy: \(item.name)"
        content.body = "From list: \(listTitle)"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: date), repeats: false)
        let request = UNNotificationRequest(identifier: item.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func cancelReminder(for item: GroceryItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [item.id.uuidString])
    }
    
    func showOutOfStockNotification(for itemName: String) {
        let content = UNMutableNotificationContent()
        content.title = "🛒 Restock Needed"
        content.body = "You’ve run out of \(itemName). Don’t forget to add it to your shopping list!"
        content.sound = .default

        // Trigger inmediato (en 1 segundo)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

}

