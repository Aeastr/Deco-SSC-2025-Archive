//
//  BackgroundType.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//


import SwiftUI

enum BackgroundType: Int, CaseIterable {
    case gradient
    case photo
    case color
    case playgrounds
    
    var title: String {
        switch self {
        case .photo:
            return "Photo"
        case .playgrounds:
            return "Image Playground"
        case .gradient:
            return "Gradient"
        case .color:
            return "Color"
        }
    }
    
    var description: String {
        switch self {
        case .photo:
            return "Use a photo from your library."
        case .playgrounds:
            return "Create a brand new image with Image Playground."
        case .gradient:
            return "Use a beautifual gradient."
        case .color:
            return "Use a simple plain color."
        }
    }
}