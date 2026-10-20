//
//  Presets.swift
//  Deco
//
//  Created by Aether on 21/02/2025.
//

import SwiftUI

struct ColorPreset: Hashable {
    let name: String
    let colors: [Color]
}

let colorPresets: [ColorPreset] = [
    presetOne,
    presetTwo,
    presetThree,
    presetFour,
    presetFive,
    presetSix,
    presetSeven,
    presetEight,
    presetNine,
    presetTen,
    presetEleven,
    presetTwelve
]

let presetOne = ColorPreset(
    name: "Cool Blues",
    colors: [
        Color(red: 0.75, green: 0.8, blue: 0.85),
        Color(red: 0.6, green: 0.7, blue: 0.8),
        Color(red: 0.45, green: 0.6, blue: 0.75),
        Color(red: 0.3, green: 0.5, blue: 0.7),
        Color(red: 0.95, green: 0.95, blue: 1.0),
        Color(red: 0.9, green: 0.9, blue: 0.95),
        Color(red: 0.8, green: 0.8, blue: 0.9),
        Color(red: 0.65, green: 0.6, blue: 0.8),
        Color(red: 0.5, green: 0.45, blue: 0.7),
        Color(red: 0.4, green: 0.35, blue: 0.6),
        Color(red: 0.25, green: 0.2, blue: 0.45),
        Color(red: 0.9, green: 0.85, blue: 0.95),
        Color(red: 0.8, green: 0.75, blue: 0.9),
        Color(red: 0.6, green: 0.55, blue: 0.75),
        Color(red: 0.3, green: 0.4, blue: 0.6),
        Color(red: 0.95, green: 0.9, blue: 0.85)
    ]
)

let presetTwo = ColorPreset(
    name: "Warm Sunset",
    colors: [
        Color(red: 1.0, green: 0.8, blue: 0.6),
        Color(red: 0.95, green: 0.75, blue: 0.55),
        Color(red: 0.9, green: 0.7, blue: 0.5),
        Color(red: 0.85, green: 0.65, blue: 0.45),
        Color(red: 0.8, green: 0.6, blue: 0.4),
        Color(red: 0.75, green: 0.55, blue: 0.35),
        Color(red: 0.7, green: 0.5, blue: 0.3),
        Color(red: 0.65, green: 0.45, blue: 0.25),
        Color(red: 0.6, green: 0.4, blue: 0.2),
        Color(red: 0.55, green: 0.35, blue: 0.15),
        Color(red: 0.5, green: 0.3, blue: 0.1),
        Color(red: 0.45, green: 0.25, blue: 0.1),
        Color(red: 0.4, green: 0.2, blue: 0.1),
        Color(red: 0.35, green: 0.15, blue: 0.1),
        Color(red: 0.3, green: 0.1, blue: 0.1),
        Color(red: 0.25, green: 0.05, blue: 0.05)
    ]
)

let presetThree = ColorPreset(
    name: "Monochrome Dream",
    colors: [
        Color(red: 0.95, green: 0.95, blue: 0.95),
        Color(red: 0.9, green: 0.9, blue: 0.9),
        Color(red: 0.85, green: 0.85, blue: 0.85),
        Color(red: 0.8, green: 0.8, blue: 0.8),
        Color(red: 0.75, green: 0.75, blue: 0.75),
        Color(red: 0.7, green: 0.7, blue: 0.7),
        Color(red: 0.65, green: 0.65, blue: 0.65),
        Color(red: 0.6, green: 0.6, blue: 0.6),
        Color(red: 0.55, green: 0.55, blue: 0.55),
        Color(red: 0.5, green: 0.5, blue: 0.5),
        Color(red: 0.45, green: 0.45, blue: 0.45),
        Color(red: 0.4, green: 0.4, blue: 0.4),
        Color(red: 0.35, green: 0.35, blue: 0.35),
        Color(red: 0.3, green: 0.3, blue: 0.3),
        Color(red: 0.25, green: 0.25, blue: 0.25),
        Color(red: 0.2, green: 0.2, blue: 0.2)
    ]
)

let presetFour = ColorPreset(
    name: "Ocean Depths",
    colors: [
        Color(red: 0.05, green: 0.15, blue: 0.25),
        Color(red: 0.1, green: 0.2, blue: 0.3),
        Color(red: 0.15, green: 0.25, blue: 0.35),
        Color(red: 0.2, green: 0.3, blue: 0.4),
        Color(red: 0.25, green: 0.35, blue: 0.45),
        Color(red: 0.3, green: 0.4, blue: 0.5),
        Color(red: 0.35, green: 0.45, blue: 0.55),
        Color(red: 0.4, green: 0.5, blue: 0.6),
        Color(red: 0.45, green: 0.55, blue: 0.65),
        Color(red: 0.5, green: 0.6, blue: 0.7),
        Color(red: 0.55, green: 0.65, blue: 0.75),
        Color(red: 0.6, green: 0.7, blue: 0.8),
        Color(red: 0.65, green: 0.75, blue: 0.85),
        Color(red: 0.7, green: 0.8, blue: 0.9),
        Color(red: 0.75, green: 0.85, blue: 0.95),
        Color(red: 0.8, green: 0.9, blue: 1.0)
    ]
)

let presetFive = ColorPreset(
    name: "Sunrise Horizon",
    colors: [
        Color(red: 0.95, green: 0.5, blue: 0.3),
        Color(red: 0.9, green: 0.55, blue: 0.35),
        Color(red: 0.85, green: 0.6, blue: 0.4),
        Color(red: 0.8, green: 0.65, blue: 0.45),
        Color(red: 0.75, green: 0.7, blue: 0.5),
        Color(red: 0.7, green: 0.75, blue: 0.55),
        Color(red: 0.65, green: 0.8, blue: 0.6),
        Color(red: 0.6, green: 0.85, blue: 0.65),
        Color(red: 0.55, green: 0.9, blue: 0.7),
        Color(red: 0.5, green: 0.95, blue: 0.75),
        Color(red: 0.45, green: 1.0, blue: 0.8),
        Color(red: 0.4, green: 0.95, blue: 0.85),
        Color(red: 0.35, green: 0.9, blue: 0.9),
        Color(red: 0.3, green: 0.85, blue: 0.95),
        Color(red: 0.25, green: 0.8, blue: 1.0),
        Color(red: 0.2, green: 0.75, blue: 0.95)
    ]
)

let presetSix = ColorPreset(
    name: "Pastel Blossom",
    colors: [
        Color(red: 0.95, green: 0.85, blue: 0.95), // Soft lavender
        Color(red: 0.9, green: 0.8, blue: 0.9),   // Pale periwinkle
        Color(red: 0.85, green: 0.75, blue: 0.85), // Dusty violet
        Color(red: 0.8, green: 0.7, blue: 0.8),   // Mauve
        Color(red: 0.75, green: 0.65, blue: 0.75), // Lilac
        Color(red: 0.7, green: 0.6, blue: 0.7),   //淡紫
        Color(red: 0.65, green: 0.55, blue: 0.65), // Purple-gray
        Color(red: 0.6, green: 0.5, blue: 0.6),   // Grape
        Color(red: 0.55, green: 0.45, blue: 0.55), // Plum
        Color(red: 0.5, green: 0.4, blue: 0.5),   // Eggplant
        Color(red: 0.45, green: 0.35, blue: 0.45), // Deep purple
        Color(red: 0.4, green: 0.3, blue: 0.4),   // Lavender
        Color(red: 0.35, green: 0.25, blue: 0.35), // Violet-gray
        Color(red: 0.3, green: 0.2, blue: 0.3),   // Muted purple
        Color(red: 0.25, green: 0.15, blue: 0.25), // Deep lavender
        Color(red: 0.2, green: 0.1, blue: 0.2)    // Muted violet
    ]
)

let presetSeven = ColorPreset(
    name: "Vivid Fusion",
    colors: [
        Color(red: 1.0, green: 0.0, blue: 0.0),
        Color(red: 0.8, green: 0.2, blue: 0.2),
        Color(red: 0.6, green: 0.4, blue: 0.4),
        Color(red: 0.4, green: 0.6, blue: 0.6),
        Color(red: 0.2, green: 0.8, blue: 0.8),
        Color(red: 0.0, green: 1.0, blue: 1.0),
        Color(red: 0.2, green: 0.8, blue: 1.0),
        Color(red: 0.4, green: 0.6, blue: 1.0),
        Color(red: 0.6, green: 0.4, blue: 1.0),
        Color(red: 0.8, green: 0.2, blue: 1.0),
        Color(red: 1.0, green: 0.0, blue: 1.0),
        Color(red: 1.0, green: 0.2, blue: 0.8),
        Color(red: 1.0, green: 0.4, blue: 0.6),
        Color(red: 1.0, green: 0.6, blue: 0.4),
        Color(red: 1.0, green: 0.8, blue: 0.2),
        Color(red: 1.0, green: 1.0, blue: 0.0)
    ]
)

let presetEight = ColorPreset(
    name: "Forest Canopy",
    colors: [
        Color(red: 0.1, green: 0.2, blue: 0.15),
        Color(red: 0.2, green: 0.3, blue: 0.2),
        Color(red: 0.3, green: 0.4, blue: 0.25),
        Color(red: 0.4, green: 0.5, blue: 0.3),
        Color(red: 0.5, green: 0.6, blue: 0.35),
        Color(red: 0.6, green: 0.7, blue: 0.4),
        Color(red: 0.7, green: 0.8, blue: 0.45),
        Color(red: 0.8, green: 0.9, blue: 0.5),
        Color(red: 0.85, green: 0.95, blue: 0.55),
        Color(red: 0.9, green: 0.95, blue: 0.6),
        Color(red: 0.88, green: 0.9, blue: 0.65),
        Color(red: 0.78, green: 0.85, blue: 0.7),
        Color(red: 0.65, green: 0.75, blue: 0.75),
        Color(red: 0.55, green: 0.65, blue: 0.8),
        Color(red: 0.45, green: 0.55, blue: 0.85),
        Color(red: 0.35, green: 0.45, blue: 0.9)
    ]
)

let presetNine = ColorPreset(
    name: "Desert Sands",
    colors: [
        Color(red: 0.95, green: 0.85, blue: 0.75),
        Color(red: 0.9, green: 0.8, blue: 0.7),
        Color(red: 0.85, green: 0.75, blue: 0.65),
        Color(red: 0.8, green: 0.7, blue: 0.6),
        Color(red: 0.75, green: 0.65, blue: 0.55),
        Color(red: 0.7, green: 0.6, blue: 0.5),
        Color(red: 0.65, green: 0.55, blue: 0.45),
        Color(red: 0.6, green: 0.5, blue: 0.4),
        Color(red: 0.55, green: 0.45, blue: 0.35),
        Color(red: 0.5, green: 0.4, blue: 0.3),
        Color(red: 0.45, green: 0.35, blue: 0.25),
        Color(red: 0.4, green: 0.3, blue: 0.2),
        Color(red: 0.35, green: 0.25, blue: 0.15),
        Color(red: 0.3, green: 0.2, blue: 0.1),
        Color(red: 0.25, green: 0.15, blue: 0.05),
        Color(red: 0.2, green: 0.1, blue: 0.0)
    ]
)

let presetTen = ColorPreset(
    name: "Midnight Sky",
    colors: [
        Color(red: 0.1, green: 0.1, blue: 0.5),
        Color(red: 0.2, green: 0.2, blue: 0.6),
        Color(red: 0.3, green: 0.3, blue: 0.7),
        Color(red: 0.4, green: 0.4, blue: 0.8),
        Color(red: 0.5, green: 0.5, blue: 0.9),
        Color(red: 0.6, green: 0.6, blue: 0.95),
        Color(red: 0.7, green: 0.7, blue: 0.975),
        Color(red: 0.75, green: 0.75, blue: 0.99),
        Color(red: 0.8, green: 0.8, blue: 1.0),
        Color(red: 0.82, green: 0.82, blue: 0.99),
        Color(red: 0.78, green: 0.78, blue: 0.98),
        Color(red: 0.7, green: 0.7, blue: 0.95),
        Color(red: 0.65, green: 0.65, blue: 0.9),
        Color(red: 0.55, green: 0.55, blue: 0.85),
        Color(red: 0.45, green: 0.45, blue: 0.8),
        Color(red: 0.35, green: 0.35, blue: 0.75)
    ]
)

let presetEleven = ColorPreset(
    name: "Berry Harvest",
    colors: [
        Color(red: 0.95, green: 0.25, blue: 0.35),
        Color(red: 0.9, green: 0.3, blue: 0.4),
        Color(red: 0.85, green: 0.35, blue: 0.45),
        Color(red: 0.8, green: 0.4, blue: 0.5),
        Color(red: 0.75, green: 0.45, blue: 0.55),
        Color(red: 0.7, green: 0.5, blue: 0.6),
        Color(red: 0.65, green: 0.55, blue: 0.65),
        Color(red: 0.6, green: 0.6, blue: 0.7),
        Color(red: 0.55, green: 0.65, blue: 0.75),
        Color(red: 0.5, green: 0.7, blue: 0.8),
        Color(red: 0.45, green: 0.75, blue: 0.85),
        Color(red: 0.4, green: 0.8, blue: 0.9),
        Color(red: 0.35, green: 0.85, blue: 0.95),
        Color(red: 0.3, green: 0.9, blue: 0.975),
        Color(red: 0.25, green: 0.95, blue: 0.99),
        Color(red: 0.2, green: 0.95, blue: 0.99)
    ]
)

let presetTwelve = ColorPreset(
    name: "Coral Reef",
    colors: [
        Color(red: 0.95, green: 0.4, blue: 0.3),
        Color(red: 0.9, green: 0.45, blue: 0.35),
        Color(red: 0.85, green: 0.5, blue: 0.4),
        Color(red: 0.8, green: 0.55, blue: 0.45),
        Color(red: 0.75, green: 0.6, blue: 0.5),
        Color(red: 0.7, green: 0.65, blue: 0.55),
        Color(red: 0.65, green: 0.7, blue: 0.6),
        Color(red: 0.6, green: 0.75, blue: 0.65),
        Color(red: 0.55, green: 0.8, blue: 0.7),
        Color(red: 0.5, green: 0.85, blue: 0.75),
        Color(red: 0.45, green: 0.9, blue: 0.8),
        Color(red: 0.4, green: 0.95, blue: 0.85),
        Color(red: 0.35, green: 0.95, blue: 0.9),
        Color(red: 0.3, green: 0.95, blue: 0.95),
        Color(red: 0.25, green: 0.9, blue: 0.95),
        Color(red: 0.2, green: 0.85, blue: 0.95)
    ]
)
