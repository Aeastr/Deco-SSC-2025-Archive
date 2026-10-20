//
//  BackgroundView.swift
//  Deco
//
//  Created by Aether on 20/02/2025.
//

import SwiftUI

struct BackgroundView: View {
    // MARK: - Environment
    
    @EnvironmentObject var backgroundData: BackgroundData
    @EnvironmentObject var gradientData: GradientData
    
    // MARK: - Helpers
    
    var preview: BackgroundType? = nil
    
    // MARK: - Cases
    
    var gradient: some View{
        Group{
            if preview != nil{
                AnimatingMeshGradient(gradientData.colors)
            }
            else{
                MeshGradientView()
            }
        }
    }
    
    var photo: some View{
        PhotoBackground(uiImage: backgroundData.uiImage, segmentedBGTestMode: backgroundData.segmentedBGTestMode)
    }
    
    var color: some View{
        backgroundData.color ?? .accentColor
    }
    
    var playgrounds: some View{
        PhotoBackground(uiImage: backgroundData.playgroundImage, backupImage: Image("playgroundGenMoon"))
    }
    
    // MARK: - Body
    
    var body: some View {
        Group{
            switch (preview ?? backgroundData.type) {
            case .gradient:
                gradient
            case .photo:
                photo
            case .color:
                color
            case .playgrounds:
                playgrounds
            }
        }
    }
    
}



