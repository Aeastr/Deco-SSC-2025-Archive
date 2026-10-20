//
//  EditorData.swift
//  Deco
//
//  Created by Aether on 21/02/2025.
//

import SwiftUI

class EditorData: ObservableObject, Observable {
    @Published var placedStickers: [PlacedSticker] = []
}

extension Binding where Value == [PlacedSticker] {
    func filtered(
        by predicate: @escaping (PlacedSticker) -> Bool
    ) -> Binding<[PlacedSticker]> {
        Binding<[PlacedSticker]>(
            get: {
                self.wrappedValue.filter(predicate)
            },
            set: { newFilteredValue in
                // Here we need to decide what updating the filtered
                // array means for the underlying stickers.
                //
                // One simple strategy is:
                // 1. Remove all stickers that match the predicate.
                // 2. Append all stickers from the new filtered value.
                //
                // Note: This might change the order of your stickers,
                // so adapt as needed.
                var current = self.wrappedValue
                current.removeAll(where: predicate)
                current.append(contentsOf: newFilteredValue)
                self.wrappedValue = current
            }
        )
    }
}

