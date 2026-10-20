//
//  StickerCreator.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//

import SwiftUI

struct StickerCreator: View {
    @Environment(\.dismiss) var dismiss
    @State private var richText = NSAttributedString(string: "", attributes: [
        .font: UIFont.systemFont(ofSize: 65)
    ])
    @State var animation: [Bool] = [false, false, false]
    @State var isFocused: Bool = true
    
    var onCreate: (NSAttributedString) -> Void
    
    var title: some View{
        VStack(alignment: .center, spacing: 20){
            Text("Add your own stickers.")
                .font(.largeTitle.weight(.semibold))
            Text("Use any emojis, stickers or\ntext that you want")
                .font(.body.weight(.regular))
        }
        .shadow(color: Color.black, radius: 20)
        .padding(.top, 45)
        .foregroundStyle(Color.white)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
    
    var textEditor: some View{
        RichTextEditor(attributedText: $richText, isFocused: $isFocused, fontSize: 65)
            .background(Material.ultraThin)
            .background(Color.black.opacity(0.4))
            .clipShape(.rect(cornerRadius: 25))
            .overlay(content: {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
            })
            .padding(.top, 30)
            .padding(.horizontal, 25)
            .frame(maxWidth: 400)
            .multilineTextAlignment(.center)
    }
    
    var body: some View {
        ScrollView{
            title
                .opacity(animation[0] ? 1 : 0)
            
            textEditor
                .opacity(animation[1] ? 1 : 0)
        }
        .safeAreaInset(edge: .bottom, content: {
            Button("Add") {
                onCreate(richText)
                dismiss()
            }
            .buttonStyle(SelectionButton())
            .padding(.bottom, 30)
            .opacity(animation[2] ? 1 : 0)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            Image("CreatorBG")
                .resizable()
                .scaledToFill()
                .opacity(0.7)
                .blur(radius: 10)
                .overlay{LinearGradient(stops: [
                    Gradient.Stop(color: Color.black.opacity(0.8), location: 0.2),
                    Gradient.Stop(color: Color.black.opacity(0.0), location: 1.0)
                ], startPoint: .top, endPoint: .bottom).ignoresSafeArea()}
        }
        .background(.black)
        .preferredColorScheme(.dark)
        .onAppear {
            let initialDelay: Double = 0.15
            let duration: Double = 0.7
            let delayInterval: Double = 0.2
            let avoid: [Int] = []

            animation.indices
                .filter { !avoid.contains($0) }
                .forEach { index in
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + initialDelay + delayInterval * Double(index)
                    ) {
                        withAnimation(.smooth(duration: duration)) {
                            animation[index] = true
                        }
                    }
                }
        }
    }
}

#Preview {
    StickerCreator(onCreate: { _ in
        
    })
    .preferredColorScheme(.dark)
}
