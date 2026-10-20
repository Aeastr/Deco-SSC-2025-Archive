//
//  PhotoBackground.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//


import SwiftUI

struct PhotoBackground: View {
    var uiImage: UIImage?
    var backupImage: Image = Image("Default Wallpaper")
    var segmentedBGTestMode = false
    
    var body: some View {
        ZStack{
            if !segmentedBGTestMode{
                if let uiImage{
                    Image(uiImage: uiImage).resizable().aspectRatio(contentMode: .fill)
                }else{
                    backupImage.resizable().aspectRatio(contentMode: .fill)
                }
            }
            else{
                Image("milodemo").resizable().aspectRatio(contentMode: .fill)
            }
        }
    }
}
