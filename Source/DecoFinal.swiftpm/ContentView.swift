//
//  ContentView.swift
//  Deco
//
//  Created by Aether on 21/02/2025.
//

import SwiftUI

struct ContentView: View {
    // MARK: - State Variables
    
    @State var canvasViewMode: CanvasViewMode = .export
    @State var safeArea: EdgeInsets?
    @State var showExport: Bool = false
    
    // MARK: - App Storage
    
    @AppStorage("firstLaunc2") var firstLaunch: Bool = true
    
    // MARK: - Computed Properties
    
    @State var deviceSize: CGSize = .zero
    @State var contentSize: CGSize = .zero
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
        }
        .onGeometryChange(for: CGSize.self) { GeometryProxy in
            return GeometryProxy.size
        } action: { newValue in
            print("device size changed \(newValue), check agasint \(UIScreen.main.bounds.size)!")
            deviceSize = newValue
        }
        .ignoresSafeArea()
        .onGeometryChange(for: EdgeInsets.self, of: { GeometryProxy in
            return GeometryProxy.safeAreaInsets
        }, action: { newValue in
            print("safe area \(newValue)")
            safeArea = newValue
        })
        .onGeometryChange(for: CGSize.self) { GeometryProxy in
            return GeometryProxy.size
        } action: { newValue in
            print("content size changed \(newValue)")
            contentSize = newValue
        }
        .overlay {
            if !firstLaunch{
                MainCanvasView(safeArea: $safeArea, showExport: $showExport, viewSize: deviceSize)
                .sheet(isPresented: $showExport) {
                    ExportView(safeArea: $safeArea, canvasSize: deviceSize)
                        .presentationCornerRadius(30)
                }
                .transition(.opacity.animation(.smooth))
            }
            
            if firstLaunch{
                Onboard(firstLaunch: $firstLaunch)
                    .transition(.opacity.animation(.smooth))
                
            }
        }
    }
}
