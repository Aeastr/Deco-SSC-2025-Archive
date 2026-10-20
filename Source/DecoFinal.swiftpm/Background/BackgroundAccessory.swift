//
//  BackgroundAccessory.swift
//  Deco
//
//  Created by Aether on 20/02/2025.
//

import SwiftUI
import PhotosUI

struct BackgroundAccessory: View {
    // MARK: - Environment Objects
    @EnvironmentObject var backgroundData: BackgroundData
    @EnvironmentObject var gradientData: GradientData
    
    // MARK: - State Variables
    
    @State var selectedColor: Color = .accentColor
    @State private var backgroundItem: PhotosPickerItem?
    @State private var showImagePlayground: Bool = false
    @State var showGradientPlayground: Bool = false
    
    // MARK: - Binding Variables
    
    @Binding var showStickerSheet: Bool
    
    // MARK: - Cases
    
    var gradient: some View{
        Button{
            showGradientPlayground.toggle()
        } label:{
            MeshGradientView()
                .frame(width: 33, height: 33)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                }
        }
    }
    
    var photo: some View{
        HStack{
            if backgroundData.hasDepth == .hasDepth{
                Menu(content: {
                    Toggle(isOn: $backgroundData.depthEffect) {
                        Label("Enable Depth Effect", systemImage: "square.2.stack.3d.top.fill")
                    }
                }, label: {
                    Image(systemName: backgroundData.depthEffect == true ? "square.2.stack.3d.top.fill" : "square.2.stack.3d")
                        .foregroundStyle(Color.primary)
                        .blendMode(.darken)
                        .font(.caption)
                        .frame(width: 33, height: 33)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            } else if backgroundData.hasDepth == .checking{
                ProgressView()
            } else{
//
                Menu(content: {
                    Toggle(isOn: $backgroundData.segmentedBGTestMode) {
                        Label("Subject Seperation Demo", systemImage: "square.2.stack.3d.top.fill")
                        Text("You can try out placing stickers behind a subject")
                    }
                }, label: {
                    Image(systemName: backgroundData.depthEffect == true ? "square.2.stack.3d.top.fill" : "square.2.stack.3d")
                        .foregroundStyle(Color.primary)
                        .blendMode(.darken)
                        .font(.caption)
                        .frame(width: 33, height: 33)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            PhotosPicker(selection: $backgroundItem) {
                Image(systemName: "photo.on.rectangle.angled")
                    .foregroundStyle(Color.primary)
                    .blendMode(.darken)
                    .font(.caption)
                    .frame(width: 33, height: 33)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    var color: some View{
        ColorPicker("Background Color", selection: $selectedColor)
            .labelsHidden()
            .onChange(of: selectedColor, initial: true){
                backgroundData.color = selectedColor
            }
            .frame(width: 33, height: 33)
            .background(.thinMaterial)
            .clipShape(Capsule())
    }
    
    var playgrounds: some View{
        Button {
            showStickerSheet = false
            showImagePlayground.toggle()
        } label: {
            Image(systemName: "apple.image.playground")
                .foregroundStyle(Color.primary)
                .blendMode(.darken)
                .font(.caption)
                .frame(width: 33, height: 33)
                .background(.thinMaterial)
                .clipShape(Capsule())
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        Group{
            switch backgroundData.type {
            case .gradient:
                gradient
            case .photo:
                photo
            case .color:
                color
            case .playgrounds:
                playgrounds
            }
        }
        .opacity(showStickerSheet ? 0 : 1)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 30)
        .onChange(of: backgroundItem) {
            Task {
                if let data = try? await backgroundItem?.loadTransferable(type: Data.self) {
                    // Convert to UIImage
                    if let uiImage = UIImage(data: data) {
                        backgroundData.uiImage = uiImage
                    }
                } else {
                    print("BG Accessory Failed to load new image data")
                }
            }
        }
        .imagePlaygroundSheet(isPresented: $showImagePlayground) { url in
            if let data = try? Data(contentsOf: url){
                if let image = UIImage(data: data){
                    backgroundData.type = .playgrounds
                    backgroundData.playgroundImage = image
                }
            }
        }
        .fullScreenCover(isPresented: $showGradientPlayground) {
            GradientCreator(gradientData){
                backgroundData.setNewBackground(type: .gradient)
                print("Gradient Completed, dismiss")
                showGradientPlayground = false
            }
        }
    }
}
