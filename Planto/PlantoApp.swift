//
//  PlantoApp.swift
//  Planto
//
//  Created by reyamnhf on 01/05/1447 AH.
//

import SwiftUI

@main
struct PlantoApp: App {
    @StateObject private var vm = PlantsViewModel()

    init() {
        NotificationManager.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            StartJourneyView()
                .environmentObject(vm)              // share VM everywhere
        }
    }
}




