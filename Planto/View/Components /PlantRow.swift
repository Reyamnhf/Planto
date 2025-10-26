//
//  PlantRow.swift
//  Planto
//
//  Created by reyamnhf on 03/05/1447 AH.
//
import SwiftUI
import UIKit

struct PlantRow: View {
    @EnvironmentObject private var vm: PlantsViewModel
    let plant: Plant

    // ثوابت بسيطة عشان يفضل الشكل ثابت
    private let checkSize: CGFloat = 26
    private let nameFont = Font.system(size: 28, weight: .semibold)

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
           
            
            HStack(spacing: 6) {
                Image(systemName: "paperplane")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.55))
                Text("in \(plant.room)")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))
            }

            HStack(alignment: .top, spacing: 12) {
                
                Button {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                    withAnimation(.easeInOut) { vm.toggleWatered(for: plant) }
                } label: {
                    Group {
                        if plant.isWateredToday {
                            ZStack {
                                Circle().fill(Color("plantogreen"))
                                Image(systemName: "checkmark")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(.black.opacity(0.75))
                            }
                            .overlay(Circle().stroke(Color("plantogreen").opacity(0.65), lineWidth: 1))
                            .shadow(color: Color("plantogreen").opacity(0.25), radius: 3, y: 1)
                        } else {
                            Circle()
                                .strokeBorder(.secondary.opacity(0.6), lineWidth: 2)
                        }
                    }
                    .frame(width: checkSize, height: checkSize)
                }
                .buttonStyle(.plain)
                .contentShape(Circle())
                .padding(.top, 2)

                
               VStack(alignment: .leading, spacing: 10) {
                    Text(plant.name)
                        .font(nameFont)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture { vm.activeSheet = .edit(plant) }

                    
                    HStack(spacing: 10) {
                        chip(icon: "sun.max", text: plant.light, tint: Color("BabyYellow"))
                        chip(icon: "drop",    text: plant.waterAmount, tint: Color("Babyblue"))
                    }
                }
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture { vm.activeSheet = .edit(plant) }

        
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                withAnimation(.easeInOut) {
                    vm.deletePlant(plant)
                }
            } label: {
                Image(systemName: "trash")
            }
        }
    }

    private func chip(icon: String, text: String, tint: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption2.bold())
            Text(text)
                .font(.callout)
        }
        .foregroundStyle(tint)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.white.opacity(0.08))
                .overlay(Capsule().stroke(.white.opacity(0.10), lineWidth: 0.6))
        )
    }
}
