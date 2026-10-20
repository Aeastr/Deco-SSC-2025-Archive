//
//  StrokeModifier.swift
//  Deco
//
//  Created by Aether on 04/02/2025.
//


import SwiftUI

@MainActor
public extension View {
    func stroke(color: Color, width: CGFloat = 1) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}

@MainActor
struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue

    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }

    @MainActor
    private func appliedStrokeBackground(content: Content) -> some View {
        content
            .padding(0)
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask(alignment: .center) {
                        mask(content: content)
                    }
            )
    }

    @MainActor
    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            if let resolvedView = context.resolveSymbol(id: id) {
                context.draw(
                    resolvedView,
                    at: .init(x: size.width / 2, y: size.height / 2)
                )
            }
        } symbols: {
            content
                .id(id)
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}

