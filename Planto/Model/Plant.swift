//
//  Plant.swift
//  Planto
//
//  Created by reyamnhf on 01/05/1447 AH.
//
import Foundation

struct Plant: Identifiable, Equatable {
    var id = UUID()
    var name: String
    var room: String
    var light: String
    var wateringDays: String
    var waterAmount: String
    var isWateredToday: Bool = false
}

