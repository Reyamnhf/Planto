//
//  StartJourneyView.swift
//  Planto
//
//  Created by reyamnhf on 01/05/1447 AH.
//
import SwiftUI

struct StartJourneyView: View {
    @EnvironmentObject private var vm: PlantsViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                if vm.plants.isEmpty {
                    OnboardingEmptyState()
                } else {
                    TodayReminderView()
                }
            }
            // One sheet source for add/edit
            .sheet(item: $vm.activeSheet) { route in
                AddEditPlantSheet(route: route)
                    .environmentObject(vm)
                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(28)
            }
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .animation(.easeInOut, value: vm.plants.count)
    }
}

private struct OnboardingEmptyState: View {
    @EnvironmentObject private var vm: PlantsViewModel

    var body: some View {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 10) {
                Text("My Plants 🌱")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Rectangle().fill(.white.opacity(0.30)).frame(height: 1)
            }
            .padding(.horizontal, 16)
            .padding(.top, 6)

            Image("cutePlant")
                .resizable().scaledToFit()
                .frame(width: 164, height: 200)
                .padding(.top, 30)

            VStack(spacing: 8) {
                Text("Start your plant journey!")
                    .font(.title2).foregroundColor(.white).fontWeight(.semibold)
                Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(maxWidth: 340)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 8)

            Spacer()

            Button {
                vm.activeSheet = .add
            } label: {
                Text("Set Plant Reminder")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(LiquidGlassButtonStyle(height: 54, tint: Color("plantogreen")))
            .shadow(color: Color("plantogreen").opacity(0.55), radius: 34, y: 16)
            .padding(.horizontal, 40)
            .padding(.bottom, 28)
        }
    }
}

#Preview {
    StartJourneyView()
        .environmentObject(PlantsViewModel())
}
