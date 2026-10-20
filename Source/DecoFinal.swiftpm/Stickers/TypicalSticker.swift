//
//  TypicalSticker.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//


import SwiftUI

struct TypicalSticker: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding(5)
            .stroke(color: Color.white, width: 2)
            .foregroundStyle(Color.black)
            .padding(-5)
    }
}
