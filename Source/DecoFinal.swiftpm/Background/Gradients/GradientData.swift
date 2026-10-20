//
//  GradientData.swift
//  Deco
//
//  Created by Aether on 21/02/2025.
//

import SwiftUI

class GradientData: ObservableObject, Observable {
    
    @Published var pointModels: [PointModel] = [
        PointModel(position: [0.0, 0.0]),
        PointModel(position: [0.33, 0.0]),
        PointModel(position: [0.66, 0.0]),
        PointModel(position: [1.0, 0.0]),
        PointModel(position: [0.0, 0.4]),
        PointModel(position: [0.33, 0.4]),
        PointModel(position: [0.66, 0.4]),
        PointModel(position: [1.0, 0.4]),
        PointModel(position: [0.0, 0.8]),
        PointModel(position: [0.33, 0.8]),
        PointModel(position: [0.66, 0.8]),
        PointModel(position: [1.0, 0.8]),
        PointModel(position: [0.0, 1.0]),
        PointModel(position: [0.33, 1.0]),
        PointModel(position: [0.66, 1.0]),
        PointModel(position: [1.0, 1.0])
    ]
    @Published var colors: [Color] = [
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
    @Published var hasGrain: Bool = false
    
    // check if we should act like the user is editing..
    @Published var hasUserCreated: Bool = false
}
