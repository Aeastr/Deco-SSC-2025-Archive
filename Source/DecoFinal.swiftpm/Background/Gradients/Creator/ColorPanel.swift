//
//  ColorPanel.swift
//  Deco
//
//  Created by Aether on 21/02/2025.
//

import SwiftUI

struct ColorPanel: View {
    // MARK: - Environment
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Binding Variables
    
    @Binding var colors: [Color]
    
    // MARK: - Constants
    
    var columns: Int = 4
    
    // MARK: - Computed Properties
    
    private var gridItems: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 10), count: columns)
    }
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(colors.indices, id: \.self) { index in
                        Swatch(color: Binding(get: {
                            colors[index]
                        }, set: { Value in
                            colors[index] = Value
                        }))
                    }
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Gradient Colors")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done"){
                        withAnimation {
                            dismiss()
                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct Swatch: View {
    @State var swatchSize: CGSize = .zero
    @State var pickerSize: CGSize = .zero
    @Binding var color: Color
    var body: some View {
        color
            .frame(height: 80)
            .onGeometryChange(for: CGSize.self, of: { GeometryProxy in
                return GeometryProxy.size
            }, action: { newValue in
                swatchSize = newValue
            })
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1.5)
            )
            .overlay {
                ColorPicker("Gradient Color", selection: $color)
                .labelsHidden()
                .onGeometryChange(for: CGSize.self, of: { GeometryProxy in
                    return GeometryProxy.size
                }, action: { newValue in
                    pickerSize = newValue
                })
                .scaleEffect(x: swatchSize.width / pickerSize.width,
                             y: swatchSize.height / pickerSize.height)
                .blendMode(.destinationOver)
            }
    }
}

#Preview {
    @Previewable @State var colors: [Color] = [
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
    
    ColorPanel(colors: $colors)
        .environmentObject(BackgroundData())
        .environmentObject(GradientData())
        .environmentObject(EditorData())
}
