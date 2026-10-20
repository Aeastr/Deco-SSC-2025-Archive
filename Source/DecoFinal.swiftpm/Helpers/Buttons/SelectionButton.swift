//
//  SelectionButton.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//


import SwiftUI

struct SelectionButton: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .foregroundStyle(.black)
            .background(Color.white.opacity(0.85))
            .clipShape(Capsule())
            .animation(.smooth) { body in
                body
                    .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            }
            .sensoryFeedback(trigger: configuration.isPressed) { oldValue, newValue in
                return newValue ? .impact(flexibility: .soft, intensity: 0.5) : .impact(flexibility: .rigid, intensity: 0.4)
            }
    }
}
