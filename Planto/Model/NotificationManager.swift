//
//  NotificationManager.swift
//  Planto
//
//  Created by reyamnhf on 03/05/1447 AH.
//
import UserNotifications
import Foundation

enum NotificationManager {
    static func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

   
    static func cancel(for plantID: UUID) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [plantID.uuidString])
    }

    /// Schedule a daily reminder
    static func scheduleDaily(for plant: Plant, hour: Int = 9, minute: Int = 0) {
        let content = UNMutableNotificationContent()
        content.title = "Water \(plant.name)"
        content.body  = "Room: \(plant.room) • \(plant.waterAmount)"
        content.sound = .default

        var comps = DateComponents()
        comps.hour = hour
        comps.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
        let request = UNNotificationRequest(
            identifier: plant.id.uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

   
    static func scheduleTest(for plant: Plant, in seconds: TimeInterval = 10) {
        let content = UNMutableNotificationContent()
        content.title = "Planto \(plant.name)"
        content.body  = "Hey! let's water your plant"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(
            identifier: "test-\(plant.id.uuidString)",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }
}

