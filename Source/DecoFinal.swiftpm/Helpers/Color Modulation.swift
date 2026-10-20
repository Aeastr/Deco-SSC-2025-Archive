//
//  Color Modulation.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//

import SwiftUI

extension Color {
    func modulate(with amplitude: Double, phase: Double, offset: Double)
    -> Color {
        // get underlying UIColor components
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        // modulate each component - add a small offset based on a sine wave
        // make sure the components remain in the [0,1] range!!
        let modulatedRed = min(max(red + CGFloat(amplitude * sin(phase + offset)), 0), 1)
        let modulatedGreen = min(max(green + CGFloat(amplitude * sin(phase + offset)), 0), 1)
        let modulatedBlue = min(max(blue + CGFloat(amplitude * sin(phase + offset)), 0), 1)
        
        return Color(red: Double(modulatedRed),
                     green: Double(modulatedGreen),
                     blue: Double(modulatedBlue),
                     opacity: Double(alpha)
        )
    }
}
