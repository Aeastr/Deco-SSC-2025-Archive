//
//  InteractiveRectangleView.swift
//  SwiftStudentChallenge
//
//  Created by Aether on 04/02/2025.
//

import SwiftUI

struct InteractiveStickerView: View {
    let id: UUID
    @Binding var sticker: PlacedSticker
    @Binding var selectedStickerId: UUID?
    var onRemove: () -> Void
    
    @Environment(\.colorScheme) var colorScheme
    // temp
    // when we drag, dont edit the sticker.position directly, etc
    @State private var positionOffset: CGSize = .zero
    @State private var rotationOffset: Angle? = nil
    @State private var scaleOffset: CGFloat = 1
    @State private var textScaleOffset: CGFloat? = nil
    
    // Instead of using scaleEffect, update the frame size directly.
    @State private var baseSize: CGSize?
    @State private var initialBaseSize: CGSize = CGSize(width: 200, height: 200)
    @State private var sizeSet: Bool = false
    
    private var isSelected: Bool { selectedStickerId == id }
    
    init(id: UUID, sticker: Binding<PlacedSticker>, selectedStickerId: Binding<UUID?>, onRemove: @escaping () -> Void) {
        self.id = id
        self._sticker = sticker
        self._selectedStickerId = selectedStickerId
        self.onRemove = onRemove
    }
    
    // MARK: - Computed Properties
    
    var displayTextScale: Double{
        textScaleOffset ?? sticker.textScale
    }
    
    var displayRotation: Angle{
        rotationOffset ?? sticker.rotation
    }
    
    var displayWidth: CGFloat{
        baseSize?.width ?? sticker.size.width
    }
    
    var displayHeight: CGFloat{
        baseSize?.height ?? sticker.size.height
    }
    
    var body: some View {
        // The entire view (sticker + delete button) is wrapped in a ZStack.
        ZStack(alignment: .topTrailing) {
            sticker.template.content
            
                .scaleEffect(sticker.template.isText ? displayTextScale : 1)
                .onGeometryChange(for: CGSize.self) { GeometryProxy in
                    return GeometryProxy.size
                } action: { newValue in
                    if !sizeSet{
                        initialBaseSize = newValue
                        if !sticker.initalized{
                            sticker.size = newValue
                        }
                        sticker.initalized = true
                        sizeSet = true
                    }
                }
            
                .frame(width: displayWidth * scaleOffset, height: displayHeight * scaleOffset)
                .padding(22)
                .contentShape(Rectangle())
                .background {
                    if isSelected{
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Material.ultraThinMaterial)
                            .opacity(0.85)
                        
                    }
                }
            
                .overlay {
                    if isSelected{
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color("systemBG").opacity(0.8), lineWidth: 2)
                            .padding(-5)
                    }
                }
        }
        
        .overlay {
            let dx = Int((sticker.position.width + positionOffset.width).rounded())
            let dy = Int((sticker.position.height + positionOffset.height).rounded())
            let components: [String] = [
                dx != 0 ? "\(dx)" : nil,
                dy != 0 ? "\(dy)" : nil
            ].compactMap { $0 }
            
            if positionOffset == .zero {
                EmptyView()
            } else {
                HStack {
                    Text(components.joined(separator: ", "))
                }
                .font(.caption2)
                .padding(7)
                .padding(.horizontal, 3)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .rotationEffect(-(sticker.rotation))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .offset(y: 50)
                .transition(.opacity)
            }
        }
        // Apply rotation and dragging to the entire sticker
        .rotationEffect(displayRotation)
        
        .contentShape(Rectangle())
        .offset(x: sticker.position.width + positionOffset.width,
                y: sticker.position.height + positionOffset.height)
        // Select the sticker when tapped.
        .onTapGesture { selectedStickerId = id }
        // Drag Gesture for moving.
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    selectedStickerId = id
                    withAnimation(.easeInOut(duration: 0.1)) {
                        positionOffset = value.translation
                    }
                }
                .onEnded { value in
                    sticker.position.width += value.translation.width
                    sticker.position.height += value.translation.height
                    positionOffset = .zero
                }
        )
        // Magnification Gesture for resizing (updating the frame size).
        .simultaneousGesture(
            MagnificationGesture()
                .onChanged { value in
                    print("magval \(value)")
                    scaleOffset = value
                    textScaleOffset = value * sticker.textScale
                    
                    
                    print("tSO \(sticker.textScale + value - 1)")
                }
                .onEnded { _ in
                    sticker.size = CGSize(width: displayWidth * scaleOffset, height: displayHeight * scaleOffset)
                    if let textScaleOffset{
                        sticker.textScale = textScaleOffset
                    }
                    textScaleOffset = nil
                    scaleOffset = 1.0
                }
        )
        // Rotation Gesture with snapping to multiples of 45°.
        .simultaneousGesture(
            RotationGesture()
                .onChanged { angle in
                    rotationOffset = sticker.rotation + angle
                }
                .onEnded { angle in
                    let finalAngle = displayRotation.degrees
                    let snapInterval = 45.0
                    let threshold = 5.0
                    let roundedAngle = (finalAngle / snapInterval).rounded() * snapInterval
                    if abs(finalAngle - roundedAngle) < threshold {
                        withAnimation(.easeOut) {
                            sticker.rotation = Angle(degrees: roundedAngle)
                            rotationOffset = nil
                        }
                    } else {
                        if let rotationOffset {
                            sticker.rotation = rotationOffset
                        }
                        rotationOffset = nil
                    }
                }
        )
        .overlay(alignment: .bottomTrailing) {
            if isSelected{
                Menu {
                    Button(
                        "Move to \(sticker.background ? "Foreground" : "Background")",
                        systemImage: sticker.background ? "square.2.layers.3d.top.filled" : "square.2.layers.3d.bottom.filled")
                    {
                        sticker.background.toggle()
                    }
                    ControlGroup{
                        
                        let adjustment: Double = 10
                        Button(action: {
                            withAnimation(.snappy) {
                                sticker.rotation = sticker.rotation - Angle(degrees: adjustment)
                            }
                        }, label: {
                            Label("-\(Int(adjustment))º", systemImage: "rotate.left")
                        })
                        .menuActionDismissBehavior(.disabled)
                        
                        Button(action: {
                            withAnimation(.snappy) {
                                sticker.rotation = sticker.rotation + Angle(degrees: adjustment)
                            }
                        }, label: {
                            Label("+\(Int(adjustment))º", systemImage: "rotate.right")
                        })
                        .menuActionDismissBehavior(.disabled)
                        
                    }
                    
                    Divider()
                    
                    Button("Remove", systemImage: "minus", role: .destructive){
                        selectedStickerId = nil
                        onRemove()
                    }
                    
                    Menu {
                        Button("All", systemImage: "scope") {
                            withAnimation(.snappy) {
                                baseSize = initialBaseSize
                                sticker.position = .zero
                                sticker.rotation = .zero
                            }
                        }
                        Button("Size", systemImage: "arrow.up.left.and.arrow.down.right") {
                            withAnimation(.snappy) {
                                baseSize = initialBaseSize
                            }
                        }
                        Button("Position", systemImage: "arrow.up.and.down.and.arrow.left.and.right") {
                            withAnimation(.snappy) {
                                sticker.position = .zero
                            }
                        }
                        Button("Rotation", systemImage: "rotate.left") {
                            withAnimation(.snappy) {
                                sticker.rotation = .zero
                            }
                        }
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                    
                } label: {
                    ZStack{
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.primary)
                            .brightness(colorScheme == .dark ? 0 : -1.3)
                            .blendMode(.overlay)
                    }
                    .font(.title3.weight(.bold))
                    .padding(15)
                    .background(Material.thin)
                    .clipShape(Capsule())
                }
                .buttonStyle(PulseButton())
                .rotationEffect(-displayRotation)
                .labelsHidden()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(-5)
                .rotationEffect(displayRotation)
                .offset(x: sticker.position.width + positionOffset.width,
                        y: sticker.position.height + positionOffset.height)
                .padding(-10)
                
                
            }
            
        }
    }
}
