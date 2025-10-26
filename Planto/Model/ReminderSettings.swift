//
//  ReminderSettings.swift
//  Planto
//
//  Created by reyamnhf on 01/05/1447 AH.
//
import Foundation

struct ReminderSettings: Equatable {
    var name: String = ""
    var room: Room = .kitchen
    var light: Light = .fullSun
    var wateringDays: Watering = .everyDay
    var waterAmount: String = "20–50 ml"
    var timeWindow: String = "20–30 min"

    var isValid: Bool { !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    enum Room: String, CaseIterable {
        case kitchen, bedroom, livingRoom, balcony, office
        var label: String {
            switch self {
            case .kitchen: return "Kitchen"
            case .bedroom: return "Bedroom"
            case .livingRoom: return "Living Room"
            case .balcony: return "Balcony"
            case .office: return "Office"
            }
        }
    }

    enum Light: String, CaseIterable {
        case low = "Low", medium = "Medium", bright = "Bright", fullSun = "Full sun"
    }

    enum Watering: String, CaseIterable {
        case everyDay = "Every day"
        case every2Days = "Every 2 days"
        case twiceAWeek = "Twice a week"
        case weekly = "Weekly"
    }
}

