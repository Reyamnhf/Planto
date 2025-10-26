//
//  AddEditPlantSheet.swift
//  Planto
//
//  Created by reyamnhf on 01/05/1447 AH.
//
import SwiftUI

struct AddEditPlantSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var vm: PlantsViewModel
    let route: PlantsViewModel.SheetRoute
    

    @State private var form = ReminderSettings()
    
    private let cardCorner: CGFloat = 22
    private let fieldCorner: CGFloat = 22
    private let rowHeight: CGFloat = 54
    private let horizontalPad: CGFloat = 18
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.75).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    titleBar
                    
                   
                    VStack(alignment: .leading, spacing: 8) {
                        roundedTextField(title: "Plant Name", prompt: "", text: $form.name)
                    }
                    
                    card {
                        groupRow(icon: "paperplane", title: "Room", value: form.room.label) {
                            menuRoom
                        }
                        dividerLine
                        groupRow(icon: "sun.max", title: "Light", value: form.light.rawValue) {
                            menuLight
                        }
                    }
                    
                    card {
                        groupRow(icon: "drop", title: "Watering Days", value: form.wateringDays.rawValue) {
                            menuWatering
                        }
                        dividerLine
                        groupRow(icon: "drop", title: "Water", value: form.waterAmount) {
                            menuWater
                        }
                    }
                    
                    if case .edit(let p) = route {
                        Button(role: .destructive) {
                            vm.deletePlant(p)   // remove from list
                            dismiss()           // close the sheet
                        } label: {
                            Text("Delete Reminder")//زر احمر
                                .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.red.opacity(0.9))
                                            )
                        }
                        .buttonStyle(LiquidGlassButtonStyle(height: 52, isDestructive: true))
                        .padding(.top, 6)
                    }
                }
                .padding(.horizontal, horizontalPad)
                .padding(.top, 10)
                .padding(.bottom, 12)
            }
        }
        .onAppear { preloadIfEditing() }
        .preferredColorScheme(.dark)
    }
    
  
    private var titleBar: some View {
        HStack {
            CircleIconButton(systemName: "xmark") { dismiss() }
            Spacer()
            Text("Set Reminder")
                .font(.headline)
                .foregroundStyle(.white)
            Spacer()
            CircleIconButton(
                systemName: "checkmark",
                tint: Color("plantogreen"),
                bgOpacity: form.isValid ? 0.28 : 0.10
            ) { if form.isValid { save() } }
                .disabled(!form.isValid)
                .opacity(form.isValid ? 1 : 0.6)
        }
    }
    
    private func card<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(spacing: 0) {
            content()
        }
        .background(Color.white.opacity(0.09))
        .clipShape(RoundedRectangle(cornerRadius: cardCorner, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cardCorner, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
    
    private var dividerLine: some View {
        Rectangle()
            .fill(.white.opacity(0.08))
            .frame(height: 0.5)
            .padding(.leading, 50)
    }
    
    private func roundedTextField(title: String, prompt: String, text: Binding<String>) -> some View {
        TextField(title, text: text)                      
            .textInputAutocapitalization(.words)
            .disableAutocorrection(false)
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: fieldCorner, style: .continuous)
                    .fill(.white.opacity(0.10))
            )
            .overlay(
                RoundedRectangle(cornerRadius: fieldCorner, style: .continuous)
                    .stroke(.white.opacity(0.16), lineWidth: 1)
            )
            .padding(.top, 4)
    }

    private func groupRow<Content: View>(
        icon: String,
        title: String,
        value: String,
        @ViewBuilder menu: @escaping () -> Content
    ) -> some View {
        Menu {
            menu()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.white.opacity(0.92))
                
                Text(title)
                    .foregroundStyle(.white)
                    .font(.body)
                
                Spacer()
                
                Text(value)
                    .foregroundStyle(.white.opacity(0.72))
                    .font(.body)
                
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .frame(height: rowHeight)
            .contentShape(Rectangle())
        }
    }
    
    
    private var menuRoom: some View {
        ForEach(ReminderSettings.Room.allCases, id: \.self) { r in
            Button(r.label) { form.room = r }
        }
    }
    
    private var menuLight: some View {
        ForEach(ReminderSettings.Light.allCases, id: \.self) { l in
            Button(l.rawValue) { form.light = l }
        }
    }
    
    private var menuWatering: some View {
        ForEach(ReminderSettings.Watering.allCases, id: \.self) { w in
            Button(w.rawValue) { form.wateringDays = w }
        }
    }
    
    private var menuWater: some View {
        ForEach(["15–30 ml", "20–50 ml", "50–80 ml"], id: \.self) { amt in
            Button(amt) { form.waterAmount = amt }
        }
    }
    
    
    private func preloadIfEditing() {
        if case .edit = route {
            form = ReminderSettings(name: "Plant Name")
        }
    }

    private func save() {
        let trimmed = form.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        form.name = trimmed

        switch route {
        case .add:
            vm.addPlant(from: form)
        case .edit(let p):
            vm.updatePlant(p, from: form)
        }
        dismiss()
    }

}
private struct CircleIconButton: View {
    var systemName: String
    var tint: Color = .white
    var bgOpacity: Double = 0.18
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.body.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Circle().fill(tint.opacity(bgOpacity)))
        }
        .buttonStyle(.plain)
    }
}
    

#Preview("Sheet – Add") {
    AddEditPlantSheet(route: .add)
        .environmentObject(PlantsViewModel())
        .background(Color.black.ignoresSafeArea())
}

#Preview("Sheet – Edit") {
    AddEditPlantSheet(
        route: .edit(
            Plant(
                name: "Pothos",
                room: "Bedroom",
                light: "Full sun",
                wateringDays: "Every day",
                waterAmount: "20–50 ml"
            )
        )
    )
    .environmentObject(PlantsViewModel())
    .background(Color.black.ignoresSafeArea())
}
