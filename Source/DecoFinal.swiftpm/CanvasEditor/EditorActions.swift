//
//  EditorActions.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//

import SwiftUI

struct EditorActions: View {
    @Binding var showStickerSheet: Bool
    @Binding var stickerSheetHeight: CGFloat
    @Binding var canvasViewMode: CanvasViewMode
    
    var body: some View {
        ZStack{
            Button(action: {
                withAnimation(.snappy){
                    if showStickerSheet{
                        stickerSheetHeight = .zero
                    }
                    showStickerSheet.toggle()
                }
            }, label: {
                Label(showStickerSheet ? "Close" : "Add", systemImage: showStickerSheet ? "xmark" : "plus")
                    .font(.headline.weight(.semibold))
                                        .padding(.trailing, 3.5)
            })
            .buttonStyle(StatusButton())
            BackgroundAccessory(showStickerSheet: $showStickerSheet)
        }
        .dynamicTypeSize(.xLarge...)
        .labelsHidden()
        .frame(maxWidth: .infinity)
        .offset(y: -stickerSheetHeight - 20)
        .animation(.snappy(duration: 0.5), value: stickerSheetHeight)
        .opacity([.preview, .export].contains(canvasViewMode) ? 0 : 1)
    }
}
