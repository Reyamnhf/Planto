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
    @Published var activeSheet: SheetRoute? = nil
    @Published var plants: [Plant] = []
    @Published var lastResetDate: Date? = nil

    // Sheet routes: add or edit a specific plant
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

    func addPlant(from r: ReminderSettings) {
        let name = r.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }

        let new = Plant(
            name: name,
            room: r.room.label,
            light: r.light.rawValue,
            wateringDays: r.wateringDays.rawValue,
            waterAmount: r.waterAmount,
            isWateredToday: false
        )
        plants.append(new)
        NotificationManager.scheduleDaily(for: new)
    }

    func updatePlant(_ plant: Plant, from r: ReminderSettings) {
        guard let idx = plants.firstIndex(of: plant) else { return }
        plants[idx].name         = r.name.trimmingCharacters(in: .whitespacesAndNewlines)
        plants[idx].room         = r.room.label
        plants[idx].light        = r.light.rawValue
        plants[idx].wateringDays = r.wateringDays.rawValue
        plants[idx].waterAmount  = r.waterAmount

        NotificationManager.cancel(for: plant.id)         // reschedule
        NotificationManager.scheduleDaily(for: plants[idx])
    }

    func deletePlant(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        NotificationManager.cancel(for: plant.id)         // cancel
    }

    func toggleWatered(for plant: Plant) {
        guard let idx = plants.firstIndex(of: plant) else { return }

        
        plants[idx].isWateredToday.toggle()

        //move the items in the array
        let moved = plants.remove(at: idx)
        if moved.isWateredToday {
            plants.append(moved)
        } else {
            plants.insert(moved, at: 0)
        }
    }

    var progress: Double {
        guard !plants.isEmpty else { return 0 }
        return Double(plants.filter { $0.isWateredToday }.count) / Double(plants.count)
    }

    var allDone: Bool {
        !plants.isEmpty && plants.allSatisfy { $0.isWateredToday }
    }

    // MARK: - Quick test notification
    func testNotification(for plant: Plant) {
        NotificationManager.scheduleTest(for: plant, in: 10)
    }
    
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
   

    
    





