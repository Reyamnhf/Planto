//
//  PlantsViewModel.swift
//  Planto
//
//  Created by reyamnhf on 01/05/1447 AH.
//
import SwiftUI
import Combine

@MainActor
final class PlantsViewModel: ObservableObject {
    // MARK: - Published State
    @Published var activeSheet: SheetRoute? = nil
    @Published var plants: [Plant] = []
    @Published var lastResetDate: Date? = nil

    // وقت التذكير اليومي الافتراضي (9:00)
    @Published var dailyHour: Int = 9
    @Published var dailyMinute: Int = 0

    // MARK: - Reminder Time (Daily)
    /// تغيير وقت التذكير اليومي وإعادة جدولة جميع النباتات
    func applyReminderTime(hour: Int, minute: Int) {
        dailyHour = hour
        dailyMinute = minute

        for p in plants {
            NotificationManager.shared.cancel(for: p.id)
            NotificationManager.shared.scheduleDaily(for: p, hour: hour, minute: minute)
        }
    }

    // MARK: - Sheet Routing
    enum SheetRoute: Identifiable, Equatable {
        case add
        case edit(Plant)

        var id: String {
            switch self {
            case .add: return "add"
            case .edit(let p): return "edit-\(p.id.uuidString)"
            }
        }
        static func ==(lhs: SheetRoute, rhs: SheetRoute) -> Bool { lhs.id == rhs.id }
    }

    // MARK: - CRUD
    func addPlant(from r: ReminderSettings) {
        let new = Plant(
            id: UUID(),
            name: r.name.trimmingCharacters(in: .whitespacesAndNewlines),
            room: r.room.label,
            light: r.light.rawValue,
            wateringDays: r.wateringDays.rawValue,
            waterAmount: r.waterAmount,
            isWateredToday: false
        )

        plants.append(new)

        // إشعار يومي للنبتة الجديدة على الوقت الحالي المختار
        NotificationManager.shared.scheduleDaily(
            for: new,
            hour: dailyHour,
            minute: dailyMinute
        )
    }

    func updatePlant(_ plant: Plant, from r: ReminderSettings) {
        guard let idx = plants.firstIndex(of: plant) else { return }

        plants[idx].name         = r.name.trimmingCharacters(in: .whitespacesAndNewlines)
        plants[idx].room         = r.room.label
        plants[idx].light        = r.light.rawValue
        plants[idx].wateringDays = r.wateringDays.rawValue
        plants[idx].waterAmount  = r.waterAmount

        // إلغاء إشعار القديم ثم إعادة جدولة إشعار النبتة بالقيم الحالية
        NotificationManager.shared.cancel(for: plant.id)
        NotificationManager.shared.scheduleDaily(
            for: plants[idx],
            hour: dailyHour,
            minute: dailyMinute
        )
    }

    func deletePlant(_ plant: Plant) {
        // ألغِ إشعار النبتة أولاً
        NotificationManager.shared.cancel(for: plant.id)
        // احذف من القائمة
        plants.removeAll { $0.id == plant.id }
    }

    // MARK: - Watering toggle + ordering
    func toggleWatered(for plant: Plant) {
        guard let idx = plants.firstIndex(of: plant) else { return }

        plants[idx].isWateredToday.toggle()

        // نقل العنصر في المصفوفة: غير المُسقاة في الأعلى، المُسقاة بالأسفل
        let moved = plants.remove(at: idx)
        if moved.isWateredToday {
            plants.append(moved)
        } else {
            plants.insert(moved, at: 0)
        }
    }

    // MARK: - Progress / All-done
    var progress: Double {
        guard !plants.isEmpty else { return 0 }
        return Double(plants.filter { $0.isWateredToday }.count) / Double(plants.count)
    }

    var allDone: Bool {
        !plants.isEmpty && plants.allSatisfy { $0.isWateredToday }
    }

    // MARK: - Daily rollover (reset wateredToday at start of new day)
    func rolloverIfNeeded() {
        let today = Calendar.current.startOfDay(for: Date())
        if lastResetDate == nil || lastResetDate! < today {
            for i in plants.indices {
                plants[i].isWateredToday = false
            }
            lastResetDate = today
            objectWillChange.send()
        }
    }
}

