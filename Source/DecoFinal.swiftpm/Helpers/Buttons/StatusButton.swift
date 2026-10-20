//
//  StatusButton.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//

import SwiftUI

struct StatusButton: ButtonStyle {
    var active: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        
            configuration.label
                .opacity(configuration.isPressed ? 0.5 : 1.0)
                .font(.footnote.weight(.semibold))
                .padding(6)
                .padding(.horizontal, 4)
                .background(.thinMaterial)
                .background(Color.accentColor.opacity(active ? 1 : 0))
                .clipShape(Capsule())
                .animation(.snappy) { body in
                    body
                        .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
                }
        
    }
}
