//
//  SegmentPhotoBackground.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//


import SwiftUI
import Vision
import CoreImage.CIFilterBuiltins

struct PhotoBackgroundSegment: View {
    // MARK: - Environment
    @EnvironmentObject var backgroundData: BackgroundData
    
    // MARK: - State Variables
    @State var image: UIImage?
    
    // MARK: - Body

    var body: some View {
        ZStack {
            if !backgroundData.segmentedBGTestMode{
                if let segmentedImage = backgroundData.segmentedImage {
                    Image(uiImage: segmentedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            else{
                Image("milodemosubject")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .task {
            image = backgroundData.uiImage
            removeBackground()
        }
        .onChange(of: backgroundData.uiImage) {
            print("backgroundData.uiImage changed, applying to image")
            backgroundData.segmentedImage = nil
            image = backgroundData.uiImage
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                removeBackground()
            }
        }
    }
    
    // MARK: - Vison Pipeline
    
    private func createMask(from inputImage: CIImage) -> CIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(ciImage: inputImage)

        do {
            try handler.perform([request])
            
            if let result = request.results?.first {
                let mask = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
                return CIImage(cvPixelBuffer: mask)
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    private func applyMask(mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        
        return filter.outputImage!
    }
    
    private func convertToUIImage(ciImage: CIImage) -> UIImage {
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
        else { fatalError("Failed to render CGImage") }
        
        return UIImage(
            cgImage: cgImage,
            scale: image?.scale ?? 1.0,
            orientation: image?.imageOrientation ?? .up
        )
    }
    
    private func removeBackground() {
        guard let uiImage = image,
              let inputImage = CIImage(image: uiImage)
        else {
            print("Failed to create CIImage")
            return
        }
        
        Task {
            guard let maskImage = createMask(from: inputImage) else {
                print("Failed to create mask")
                backgroundData.hasDepth = .noDepth
                backgroundData.segmentedImage = nil
                return
            }
            backgroundData.hasDepth = .hasDepth
            let outputImage = applyMask(mask: maskImage, to: inputImage)
            
            let croppedOutput = outputImage.cropped(to: inputImage.extent)
            
            let finalImage = convertToUIImage(ciImage: croppedOutput)
            backgroundData.segmentedImage = finalImage
        }
    }
}
