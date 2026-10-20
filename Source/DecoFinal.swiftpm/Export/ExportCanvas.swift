//
//  ExportCanvas.swift
//  Deco
//
//  Created by Aether on 21/02/2025.
//

import SwiftUI

// keeping just in case..
// pain to maintain alongside maincanvasview, we can just use that to export with

struct ExportCanvas: View {
    // MARK: - Background Properties
    
    @EnvironmentObject var backgroundData: BackgroundData
    
    // MARK: - Sticker Properties
    @EnvironmentObject var editorData: EditorData
    
    // MARK: - UI Properties
    var viewSize: CGSize
    
    // export helper
    var safeArea: EdgeInsets?
    
    // MARK: - Main Layers
    var stickerLayer: some View{
        ForEach($editorData.placedStickers) { $placed in
            InteractiveStickerView(
                id: placed.id,
                sticker: $placed,
                selectedStickerId: .constant(nil),
                onRemove: {
                   
                }
            )
            .transition(.asymmetric(insertion: .scale(scale: 1.8, anchor: .top).combined(with: .opacity).animation(.bouncy), removal: .opacity.animation(.snappy(duration: 0.2))))
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 1.5)
            .zIndex(placed.background ? 1 : 3)
        }
        .ignoresSafeArea()
        .frame(width: min(viewSize.width, viewSize.height), height: min(viewSize.width, viewSize.height))
        .padding(.top, safeArea?.top ?? 0)
        .padding(.bottom, safeArea?.bottom ?? 0)
    }
    var background: some View{
        BackgroundView()
            .frame(width: viewSize.width, height: viewSize.height, alignment: .center)
            .ignoresSafeArea()
    }
    @ViewBuilder
    func BackgroundSubject(_ segmentedImage: UIImage) -> some View{
        Image(uiImage: segmentedImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .zIndex(2)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            stickerLayer
            
            if let segmentedImage = backgroundData.segmentedImage, backgroundData.depthEffect{
                BackgroundSubject(segmentedImage)
                    .frame(width: viewSize.width, height: viewSize.height, alignment: .center)
                    .frame(width: min(viewSize.width, viewSize.height), height: min(viewSize.width, viewSize.height))
                    .frame(maxHeight: .infinity, alignment: .center)
            }
            
            StatusButtons()
                .dynamicTypeSize(.xLarge...DynamicTypeSize.xxxLarge)
                .zIndex(4)
            
        }
        .background{
            background
                .frame(width: viewSize.width, height: viewSize.height, alignment: .center)
                .frame(width: min(viewSize.width, viewSize.height), height: min(viewSize.width, viewSize.height))
        }
        .background{
            Color.black
                .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func StatusButtons() -> some View {
        GeometryReader { geometry in
            let statusBarHeight = geometry.safeAreaInsets.top
            let threshold = statusBarHeight > 10
            
            HStack(spacing: 0){
                
                Button("Change", action: {
                })
                .buttonStyle(StatusButton())
                .frame(maxWidth: .infinity, alignment: threshold ? .center : .leading)
                
                Color.clear
                    .frame(width: threshold ? 125 : nil)
                
                
                Button(action: {
                }, label: {
                    Text("Export")
                })
                .labelsHidden()
                .buttonStyle(StatusButton())
                .frame(maxWidth: .infinity, alignment: threshold ? .center : .trailing)
            }
            .frame(height: threshold ? statusBarHeight + 4 : 40)
            .edgesIgnoringSafeArea(.all)
            .padding(.horizontal, 15)
            .padding(.top, threshold ? 0 : 15)
        }
    }
}
