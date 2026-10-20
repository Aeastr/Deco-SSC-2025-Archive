//
//  BackgroundSelector.swift
//  Deco
//
//  Created by Aether on 20/02/2025.
//

import SwiftUI
import PhotosUI
import ImagePlayground

struct BackgroundSelector: View {
    // MARK: - Environment
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.supportsImagePlayground) var supportsImagePlayground
    @EnvironmentObject var backgroundData: BackgroundData
    @EnvironmentObject var gradientData: GradientData
    
    // MARK: - State Variables
    
    @State private var type: Int? = 0
    @State var animation: [Bool] = [false, false, false, false]
    @State var showGradientPlayground: Bool = false
    @State private var backgroundItem: PhotosPickerItem?
    @State private var showImagePlayground: Bool = false
    
    // MARK: - Computed Properties
    
    private var availableBackgroundTypes: [BackgroundType] {
        BackgroundType.allCases.filter { type in
            if case .playgrounds = type {
                return supportsImagePlayground
            }
            return true
        }
    }
    
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack(spacing: 0){
                ForEach(availableBackgroundTypes, id: \.self){ type in
                    BackgroundView(preview: type)
                        .containerRelativeFrame(.horizontal)
                        .clipped()
                        .overlay(content: {
                            LinearGradient(stops: [
                                Gradient.Stop(color: Color.clear, location: 0.0),
                                Gradient.Stop(color: Color.black, location: 0.7)
                            ], startPoint: .top, endPoint: .bottom)
                            .padding(.top, 130)
                        })
                        .ignoresSafeArea()
                        .anchorPreference(key: BackgroundSelectorAnchor.self, value: .bounds) { anchor in
                            return [type.rawValue: (anchors: anchor, type: type)]
                        }
                        .id(type.rawValue)
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $type)
        .overlay(alignment: .bottom, content: {
            HStack(spacing: 5){
                ForEach(availableBackgroundTypes.indices, id: \.self){ i in
                    Circle()
                        .foregroundStyle(Color.white.opacity(i == type ? 1.0 : 0.5))
                        .animation(.smooth, value: type)
                }
            }
            .frame(width: CGFloat(availableBackgroundTypes.count  * 10), height: 7)
            .padding(.bottom, 8)
        })
        .overlayPreferenceValue(BackgroundSelectorAnchor.self, alignment: .leading) { type in
            Info(pref: type)
        }
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
        .onChange(of: backgroundItem) {
            Task {
                if let data = try? await backgroundItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        backgroundData.setNewBackground(type: .photo, uiImage: uiImage)
                        dismiss()
                    }
                } else {
                    print("Failed")
                }
            }
        }
        .imagePlaygroundSheet(isPresented: $showImagePlayground, concept: "Starry Night") { url in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    backgroundData.setNewBackground(type: .playgrounds, playgroundImage: image)
                    dismiss()
                }
            }
        }
        .fullScreenCover(isPresented: $showGradientPlayground) {
            GradientCreator(gradientData){
                backgroundData.setNewBackground(type: .gradient)
                print("Gradient Completed, dismiss")
                dismiss()
            }
        }
        
    }
    
    @ViewBuilder
    func Info(pref: [Int: (anchors: Anchor<CGRect>, type: BackgroundType)]) -> some View{
        GeometryReader { proxy in
            ForEach(pref.keys.sorted(), id: \.self) { i in
                if let (anchor, type) = pref[i] {
                    VStack(spacing: 20){
                        let factor = Double(proxy[anchor].minX) / proxy[anchor].width
                        let opacity = factor < 0 ? (1.0 + 2 * factor) : (1.0 - 2 * factor)
                        let maxBlur: CGFloat = 5
                        let blurRadius = (1 - opacity) * maxBlur
                        Group{
                            VStack(spacing: 10){
                                Text(type.title)
                                    .font(.title.weight(.bold))
                                    .opacity(animation[0] ? 1.0 : 0.0)
                                    .offset(y: animation[0] ? 0 : 10)
                                Text(type.description)
                                    .font(.body.weight(.medium))
                                    .opacity(0.7)
                                    .opacity(animation[1] ? 1.0 : 0.0)
                                    .offset(y: animation[1] ? 0 : 10)
                            }
                            .offset(x: (proxy[anchor].minX * 1.3))
                            .opacity(opacity)
                            .blur(radius: blurRadius)
                            
                            Group{
                                switch type {
                                case .photo:
                                    PhotosPicker(selection: $backgroundItem,
                                                 matching: .images) {
                                        Label(backgroundData.type == .photo ? "Change" : "Pick", systemImage: "photo")
                                    }
                                case .playgrounds:
                                    Button{
                                        showImagePlayground.toggle()
                                    } label: {
                                        Label("Open", systemImage: "apple.image.playground")
                                    }
                                case .color:
                                    Button{
                                        backgroundData.setNewBackground(type: .color)
                                        dismiss()
                                    } label: {
                                        Label("Pick", systemImage: "paintpalette")
                                    }
                                case .gradient:
                                    Button{
                                        showGradientPlayground.toggle()
                                    } label: {
                                        let editCondition = backgroundData.type == .gradient && gradientData.hasUserCreated
                                        Label(editCondition ? "Edit" : "Create",
                                              systemImage: editCondition ? "pencil" : "plus"
                                        )
                                    }
                                }
                            }
                            .buttonStyle(SelectionButton())
                            .offset(x: (proxy[anchor].minX * 1.5))
                            .opacity(opacity)
                            .blur(radius: blurRadius)
                            .opacity(animation[2] ? 1.0 : 0.0)
                        }
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                    }
                    .padding(.bottom, 120)
                    .padding(.horizontal, 70)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .frame(width: proxy[anchor].width)
                }
            }
        }
    }
}

struct BackgroundSelectorAnchor: PreferenceKey {
    typealias Value = [Int: (anchors: Anchor<CGRect>, type: BackgroundType)]
    
    static var defaultValue: Value = [:]
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { (_, new) in
            new
        }
    }
}

#Preview {
    BackgroundSelector()
        .environmentObject(BackgroundData())
        .environmentObject(GradientData())
        .environmentObject(EditorData())
}


