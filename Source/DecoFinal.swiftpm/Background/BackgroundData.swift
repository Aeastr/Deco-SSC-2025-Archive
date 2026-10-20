//
//  BackgroundData.swift
//  Deco
//
//  Created by Aether on 20/02/2025.
//


import SwiftUI

enum DepthStatus{
    case hasDepth
    case noDepth
    case checking
}

class BackgroundData: ObservableObject, Observable {
    @Published var type: BackgroundType
    
    // photo + playgrounds
    @Published var uiImage: UIImage? = nil
    @Published var depthEffect: Bool = true
    @Published var hasDepth: DepthStatus = .checking
    @Published var segmentedImage: UIImage?
    @Published var playgroundImage: UIImage? // seperate element due to how backgroundview works..
    
    // color
    @Published var color: Color? = nil
    
    init(type: BackgroundType = .gradient) {
        self.type = type
    }
    
    func setNewBackground(
        type: BackgroundType,
        uiImage: UIImage? = nil,
        playgroundImage: UIImage? = nil,
        color: Color? = nil
    ){
        self.type = type
        self.uiImage = uiImage
        self.segmentedImage = nil
        self.playgroundImage = playgroundImage
        self.color = color
    }
    
    // tests
    @Published var segmentedBGTestMode = false
}
