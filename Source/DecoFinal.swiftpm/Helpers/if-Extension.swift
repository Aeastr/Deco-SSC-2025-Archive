//
//  if-Extension.swift
//  Deco
//
//  Created by Aether on 20/02/2025.
//


import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Value, Content: View>(
        _ value: Value?,
        apply: (Self, Value) -> Content
    ) -> some View {
        if let value = value {
            apply(self, value)
        } else {
            self
        }
    }
}