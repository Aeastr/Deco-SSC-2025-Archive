//
//  Exporter.swift
//  Deco
//
//  Created by Aether on 20/02/2025.
//

import SwiftUI

struct ExportView: View {
    // MARK: - Environment Objects
    
    @EnvironmentObject var backgroundData: BackgroundData
    @EnvironmentObject var gradientData: GradientData
    @EnvironmentObject var editorData: EditorData
    
    // MARK: - State Variables
    
    @State var capturedImage: UIImage?
    @State var showExport: Bool = false
    @State var animation: [Bool] = [false, false, false, false]
    @State var saveStatus = "Save"
    
    // MARK: - Binding Variables
    
    @Binding var safeArea: EdgeInsets?
    
    // MARK: - Constants
    
    var canvasSize: CGSize
    
    var body: some View {
        VStack {
            if let capturedImage{
                ExportPreview(capturedImage: capturedImage, animation: $animation)
            } else{
                Text("Failed to capture Image")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: animation[0])
        .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.3), trigger: animation[3])
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay{
            farewellSection
        }
        .background(Color.black)
        .onAppear(){
            captureCanvas()
        }
        // gradually animat screen elements in
        .onAppear {
            let initialDelay: Double = 0
            let duration: Double = 2.5
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
    
    var farewellSection: some View{
        LinearGradient(stops: [
            Gradient.Stop(color: Color.clear, location: 0.0),
            Gradient.Stop(color: Color.black, location: 0.7)
        ], startPoint: .top, endPoint: .bottom)
        .overlay(alignment: .center, content: {
            VStack(spacing: 20){
                VStack(spacing: 10){
                    Text("Masterpiece Ready")
                        .font(.title.weight(.bold))
                        .opacity(animation[1] ? 1.0 : 0.0)
                        .offset(y: animation[1] ? 0 : 10)
                        .multilineTextAlignment(.center)
                    Text("Stick it. Love it. Lock it.")
                        .font(.body.weight(.medium))
                        .opacity(0.7)
                        .opacity(animation[2] ? 1.0 : 0.0)
                        .offset(y: animation[2] ? 0 : 10)
                }
                
                Button{
                    saveImage()
                } label: {
                    Text(saveStatus)
                }
                .buttonStyle(SelectionButton())
                .background{
                    Color.white
                        .clipShape(Capsule())
                        .blur(radius: 10)
                        .opacity(0.5)
                }
                .opacity(animation[3] ? 1.0 : 0.0)
                .offset(y: animation[3] ? 0 : 10)
            }
            .foregroundStyle(.white)
            .padding(.top, 210)
        })
        .padding(.top, 150)
        .opacity(animation[1] ? 1 : 0)
    }
    
    var canvas: some View {
        MainCanvasView(safeArea: $safeArea, viewSize: canvasSize, overrideMode: .export)
            .environmentObject(backgroundData)
            .environmentObject(gradientData)
            .environmentObject(editorData)
            .frame(width: canvasSize.width, height: canvasSize.height)
    }
    
    // MARK: - Functions

    func saveImage(){
        guard let inputImage = capturedImage else {
            withAnimation(.smooth){
                saveStatus = "Error"
            }
            return
        }
        
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: inputImage)
        withAnimation(.smooth){
            saveStatus = "Saved"
        }
    }
    
    func captureCanvas() {
        let editorCanvas = canvas
        
        let renderer = ImageRenderer(content: editorCanvas)
        renderer.scale = UIScreen.main.scale
        renderer.isOpaque = true
        
        if let uiImage = renderer.uiImage {
            capturedImage = uiImage
        } else {
            saveStatus = "Error"
            print("Image rendering failed.")
        }
    }
}



struct ExportPreview: View {
    @ObservedObject var motionManager = MotionManager()
    var capturedImage: UIImage
    @Binding var animation: [Bool]
    
    var body: some View {
        let pitch = min(max(motionManager.effectivePitch * 15 , -10), 10)
        let roll = min(max(motionManager.effectiveRoll * 15 , -10), 10)
        Image(uiImage: capturedImage)
            .resizable()
            .scaledToFit()
            .mask({
                SlowRevealMask()
            })
            .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.35), trigger: abs(pitch) == 10)
            .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.35), trigger: abs(roll) == 10)
            .clipShape(.rect(cornerRadius: 40))
            .animation(.smooth, body: { body in
                body
                    .rotation3DEffect(
                        Angle(degrees: pitch),
                        axis: (x: -0.2, y: 0, z: 0)
                    )
                    .rotation3DEffect(
                        Angle(degrees: roll),
                        axis: (x: 0, y: 0.2, z: 0)
                    )
            })
            .background{
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 60))
                    .scaleEffect(x: 1.15, y: 1.04, anchor: .bottom)
                    .blur(radius: 50)
                    .saturation(3)
                    .opacity(animation[3] ? 0.5 : 0.0)
            }
            .scaleEffect(animation[0] ? 0.85 : 0.7)
        
        
    }
}

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
