//
//  MeshGradient.swift
//  Deco
//
//  Created by Aether on 20/02/2025.
//

import SwiftUI

struct MeshGradientView: View {
    @EnvironmentObject var gradientData: GradientData
    
    var points: [SIMD2<Float>] {
        gradientData.pointModels.map { $0.position }
   }
    
    var body: some View {
        MeshGradient(
            width: 4,
            height: 4,
            points: points,
            colors: gradientData.colors
        )
        .overlay {
            if gradientData.hasGrain{
                Image("Grain")
                    .resizable()
                    .opacity(0.5)
            }
        }
    }
}
