//
//  SlowReveal.swift
//  Deco
//
//  Created by Aether on 21/02/2025.
//

import SwiftUI

struct SlowRevealMask: View {
    // MARK: - State
    @State private var startTime: TimeInterval =
        Date().timeIntervalSinceReferenceDate

    // MARK: - Gradient Attributes
    private let basePoints: [SIMD2<Float>] = [
        [0.0, 0.0],  [0.33, 0.0],  [0.66, 0.0],  [1.0, 0.0],
        [0.0, 0.4],  [0.33, 0.4],  [0.66, 0.4],  [1.0, 0.4],
        [0.0, 0.8],  [0.33, 0.8],  [0.66, 0.8],  [1.0, 0.8],
        [0.0, 1.0],  [0.33, 1.0],  [0.66, 1.0],  [1.0, 1.0]
    ]
    
    // MARK: - Animation Attributes
    private let fadeInDuration: Double = 3
    private let fadeStagger: Double = 0.5
    
    // MARK: - Body

    var body: some View {
        TimelineView(.animation) { timeline in
            let now = timeline.date.timeIntervalSinceReferenceDate
            let relativeTime = now - startTime

            // existing oscillation from `AnimatingMeshGradient`
            let animatedPoints = basePoints.map { point in
                adjustedPoint(point: point, relativeTime: relativeTime)
            }

            // compute an individual fade factors
            // delay baed on co-ords
            let animatedColors = basePoints.map { point in
                // points further along in x+y will have their fade delayed proportionally
                let delay = (Double(point.x) + Double(point.y)) * fadeStagger
                let individualFadeFactor = min(
                    1.0,
                    max(0.0, (relativeTime - delay) / fadeInDuration)
                )
                return Color.black.opacity(individualFadeFactor)
            }

            MeshGradient(
                width: 4,
                height: 4,
                points: animatedPoints,
                colors: animatedColors
            )
            .ignoresSafeArea()
            
        }
        
    }

    // MARK: - Functions
    
    func adjustedPoint( point: SIMD2<Float>, relativeTime time: TimeInterval) -> SIMD2<Float> {
        let t = Float(time)
        
        // oscillation parameters
        let amplitude: Float = 0.2
        let frequency: Float = 0.1
        
        // random-ness parameters
        let noiseAmplitude: Float = 0.02
        let noiseFrequency: Float = 0.5
        
        // get new x and y for point
       
        let mainOscillationX = sin(frequency * t + point.x * .pi)
        let mainOscillationY = cos(frequency * t + point.y * .pi)
        
        let randomOffsetX = noiseAmplitude * sin(noiseFrequency * t * 1.7 + point.y * 3.14) * mainOscillationX
        let randomOffsetY = noiseAmplitude * cos(noiseFrequency * t * 2.3 + point.x * 2.71) * mainOscillationY
        
        let offsetX = amplitude * mainOscillationX + randomOffsetX
        let offsetY = amplitude * mainOscillationY + randomOffsetY
        
        // apply changes
        
        var newX = point.x
        var newY = point.y
        
        
        let tolerance: Float = 0.001
        
        // constrain movement depending on the edge
        // moving edge points too buggy..
        if abs(point.y - 0.0) < tolerance || abs(point.y - 1.0) < tolerance {
            // top/bottom edge - move horizontally only
            // newX += offsetX
        } else if abs(point.x - 0.0) < tolerance || abs(point.x - 1.0) < tolerance {
            // left/right edge - move vertically only
            // newY += offsetY
        } else {
            // interior point - adjust both directions with added randomness
            newX += offsetX
            newY += offsetY
        }
        
        // clamp the result between 0 and 1
        newX = min(max(newX, 0), 1)
        newY = min(max(newY, 0), 1)
        
        return SIMD2<Float>(newX, newY)
    }
}

#Preview {
    SlowRevealMask()
        .environmentObject(BackgroundData())
        .environmentObject(GradientData())
        .environmentObject(EditorData())
}
