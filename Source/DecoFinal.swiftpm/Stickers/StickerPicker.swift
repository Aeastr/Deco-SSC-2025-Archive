//
//  SwiftUIView.swift
//  Deco
//
//  Created by Aether on 04/02/2025.
//

import SwiftUI

// MARK: - Sticker Model

struct Sticker: Identifiable {
    let id = UUID()
    let name: String
    var isText: Bool = true
    let content: AnyView
}

// since AnyView isn’t Sendable, but we can be sure our stickers are not mutated concurrently!! - mark Sticker as @unchecked Sendable.
extension Sticker: @unchecked Sendable {}

// MARK: - Placed Sticker Model

struct PlacedSticker: Identifiable, Equatable {
    let id = UUID()
    var template: Sticker
    var initalized: Bool = false
    var position: CGSize
    var rotation: Angle = .zero
    var size: CGSize = CGSize(width: 200, height: 200)
    var textScale: Double = 1
    var background: Bool = true
    //    var userSticker
    
    static func == (lhs: PlacedSticker, rhs: PlacedSticker) -> Bool {
        lhs.id == rhs.id
    }
}


// MARK: - StickerPicker View

struct StickerPicker: View {
    @State var showStickerCreator: Bool = false
    let stickers: [Sticker]
    // Callback invoked when a sticker is tapped.
    let onStickerSelected: (Sticker) -> Void
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            let spacing: CGFloat = 10
            // A grid with 3 columns.
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: spacing),
                    count: 3
                ),
                spacing: spacing
            ) {
                Button {
                    showStickerCreator.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundStyle(Color.primary)
                        .frame(height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 30 - spacing))
                }
                .lineLimit(1)
                .minimumScaleFactor(0.2)
                
                ForEach(stickers) { sticker in
                    Button {
                        onStickerSelected(sticker)
                        dismiss()
                    } label: {
                        sticker.content
                            .frame(height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 30 - spacing))
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
                }
            }
            .padding(.top, 25)
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showStickerCreator, content: {
            StickerCreator(onCreate: { NSAttributedString in
                var swiftUIAttributedString: AttributedString
                if let converted = try? AttributedString(NSAttributedString) {
                    swiftUIAttributedString = converted
                    swiftUIAttributedString.foregroundColor = Color.black
                } else {
                    // Fallback to plain text if conversion fails
                    swiftUIAttributedString = AttributedString(NSAttributedString.string)
                }
                
                let newSticker = Sticker(
                    name: "Custom Sticker",
                    content: AnyView(
                        Text(swiftUIAttributedString)
                            .modifier(TypicalSticker())
                    )
                )
                onStickerSelected(newSticker)
                dismiss()
            })
            .presentationCornerRadius(30)
        })
    }
}
