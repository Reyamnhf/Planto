//
//  PlantoApp.swift
//  Planto
//
//  Created by reyamnhf on 01/05/1447 AH.
//
import SwiftUI
import UserNotifications

@main
struct PlantoApp: App {
    @StateObject private var vm = PlantsViewModel()

    init() {
        // عرض الإشعارات كبانر حتى لو التطبيق في المقدمة (مفيد للاختبار)
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        // اطلب الإذن مرة واحدة عند تشغيل التطبيق
        NotificationManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            StartJourneyView()
                .environmentObject(vm)
        }
    }
}

/// مندوب الإشعارات لعرض البانر في المقدمة (اختياري لكنه مفيد بالاختبار)
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
}






