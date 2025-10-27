//
//  LiquidGlassButtonStyle.swift
//  Planto
//
//  Created by reyamnhf on 01/05/1447 AH.
//
import SwiftUI

struct LiquidGlassButtonStyle: ButtonStyle {
    var height: CGFloat = 52
    var isDestructive: Bool = false
    var tint: Color = .white

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .padding(.vertical, 12)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(.ultraThinMaterial.opacity(0.28))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [.white.opacity(0.6), .white.opacity(0.15)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                )
                        )

                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(tint.opacity(configuration.isPressed ? 0.55 : 0.75))

                    AngularGradient(
                        colors: [
                            .white.opacity(0.35),
                            .white.opacity(0.07),
                            .white.opacity(0.28),
                            .white.opacity(0.06)
                        ],
                        center: .center
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .blur(radius: 24)
                    )
                    .opacity(configuration.isPressed ? 0.45 : 0.6)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(isDestructive ? Color.red.opacity(0.6) : Color.clear)
            )
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .shadow(color: .black.opacity(0.35), radius: 25, y: 10)
            .animation(.spring(response: 0.35, dampingFraction: 0.9), value: configuration.isPressed)
    }
}

