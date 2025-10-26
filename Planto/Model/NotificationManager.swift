//
//  NotificationManager.swift
//  Planto
//
//  Created by reyamnhf on 03/05/1447 AH.
//
//  NotificationManager.swift
//  Planto

import Foundation
import UserNotifications

/// مدير الإشعارات (سنجلتون)
final class NotificationManager {
    
    static let shared = NotificationManager()
    private init() {}
    
    // اطلب الإذن مرة واحدة (مثلاً في onAppear لأول شاشة)
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, err in
#if DEBUG
            print("🔔 Notifications permission granted: \(granted), error: \(String(describing: err))")
#endif
        }
    }
    
    /// إلغاء إشعار نبتة معيّنة
    func cancel(for plantID: UUID) {
        let id = requestID(for: plantID)
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id])
#if DEBUG
        print("🗑️ Cancelled notification for \(id)")
#endif
    }
    
    /// جدولة تذكير يومي لنبتة في ساعة/دقيقة محددة
    func scheduleDaily(for plant: Plant, hour: Int, minute: Int,
                       title: String = "Planto",
                       body: String? = nil) {
        
        let id = requestID(for: plant.id)
        
        // احذف أي طلب سابق لنفس المعرف قبل إضافة طلب جديد
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [id])
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body ?? "Hey! let’s water \(plant.name) 🌿"
        content.sound = .default
        
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { err in
#if DEBUG
            if let err { print("⚠️ scheduleDaily error:", err) }
            else { print("✅ Scheduled daily for \(plant.name) at \(hour):\(String(format: "%02d", minute))") }
#endif
        }
    }
    
    // ===== Helpers =====
    private func requestID(for plantID: UUID) -> String {
        "plant-\(plantID.uuidString)"
    }
    
    func scheduleDaily(for plant: Plant, hour: Int = 9, minute: Int = 0) {
        let content = UNMutableNotificationContent()
        content.title = "Time to water \(plant.name)"
        content.body = "Your \(plant.name) needs some love 🌿💧"
        content.sound = .default
        
        // 🔥 بدلاً من يومي — خليه بعد 10 ثواني فقط للاختبار
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: plant.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
