//
//  PulseButton.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//


import SwiftUI

struct PulseButton: ButtonStyle {
    var tapped: Bool? = nil
    @State private var pressTimer: Timer?
    @State private var pressDuration: Double = 0
    @State private var isPressing: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        let isPressed = tapped ?? configuration.isPressed
        
        // animate down quickly
        let pressDownAnimation: Animation = .smooth
        let damping: Double = max(6, 25 - (pressDuration * 10))
        var releaseAnimation: Animation {
            return Animation.interpolatingSpring(
                stiffness: 200,
                damping: damping)
        }
        
        // switch animations based on whether we’re currently pressing
        let activeAnimation = isPressing ? pressDownAnimation : releaseAnimation
        
        return configuration.label
            .opacity(isPressed ? 0.7 : 1)
        // scale down if pressed, else normal
            .animation(activeAnimation){ label in
                label
                    .scaleEffect(isPressing ? 0.9 : 1.0)
            }
       
            .onChange(of: isPressed) {
                if isPressed {
                    // just pressed down! reset press duration and start timer.
                    startPressTimer()
                } else {
                    // lifted finger - invalidate timer and bounce back up.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        stopPressTimer()
                    }
                }
            }
    }
    
    // MARK: - Timer Logic
    
    private func startPressTimer() {
        guard !isPressing else { return }
        isPressing = true
        pressDuration = 0
        pressTimer?.invalidate()
        pressTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            DispatchQueue.main.async {
                pressDuration += 0.02
            }
        }
    }
    
    private func stopPressTimer() {
        guard isPressing else { return }
        isPressing = false
        pressTimer?.invalidate()
        pressTimer = nil
    }
}
