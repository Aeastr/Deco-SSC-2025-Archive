//
//  GradientCreator.swift
//  Deco
//
//  Created by Aether on 20/02/2025.
//

import SwiftUI

struct PointModel: Identifiable, Hashable {
    var id = UUID()
    var position: SIMD2<Float>
}

enum CreatorSheet: Int, Identifiable{
    case colors
    
    var id: Int {
        return self.rawValue
    }
}

struct GradientCreator: View {
    // MARK: - Environment
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gradientData: GradientData
    
    // MARK: - State
    @State var sheetPresented = true
    @State var viewSize: CGSize = .zero
    @State var sheetSize: CGSize = .zero
    @State var actionsSize: CGSize = .zero
    @State var sheet: CreatorSheet?
    
    // MARK: - Gradient
    @State var layoutEditMode = false
    @State var hasGrain = false
    // Mesh
    var points: [SIMD2<Float>] {
        pointModels.map { $0.position }
    }
    // pass to view
    let onGradientCompleteion: () -> Void
    
    // Animations for points
    @State private var pointsMoved: [Bool] = [false, false, false]
    
    @State var pointModels: [PointModel]
    @State var colors: [Color]
    @State var width: Int = 4
    @State var height: Int = 4
    
    init(_ data: GradientData, onGradientCompleteion: @escaping () -> Void){
        self.pointModels = data.pointModels
        self.colors = data.colors
        self.onGradientCompleteion = onGradientCompleteion
    }
    
    var gradient: some View{
        MeshGradient(
            width: width,
            height: height,
            points: points,
            colors: colors
        )
        .overlay {
            if hasGrain{
                Image("Grain")
                    .resizable()
                    .opacity(0.5)
            }
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: sheet != nil ? .top : .center){
            Color.black
                .sheet(item: $sheet, onDismiss: {
                    withAnimation(.smooth){
                        sheetSize = .zero
                    }
                }, content: { Sheet in
                    Group{
                        switch Sheet {
                        case .colors:
                            ColorPanel(colors: $colors)
                                .presentationDetents([.medium])
                        default:
                            EmptyView()
                        }
                    }
                    
                    .onGeometryChange(for: CGSize.self, of: { proxy in
                        return proxy.size
                    }, action: { newValue in
                        withAnimation(.smooth){
                            sheetSize = newValue
                        }
                    })
                    .presentationBackground(Material.thin)
                    .presentationBackgroundInteraction(.enabled)
                    .presentationCornerRadius(30)
                    
                })
                .onGeometryChange(for: CGSize.self, of: { proxy in
                    return proxy.size
                }, action: { newValue in
                    viewSize = newValue
                })
                .ignoresSafeArea()
            
            StatusButtons()
            
            VStack(spacing: 25){
                gradient
                    .clipShape(.rect(cornerRadius: 30))
                    .overlay {
                        GeometryReader { geo in
                            ForEach(pointModels.indices, id: \.self) { index in
                                Circle()
                                    .fill(Color.white
                                        .opacity(layoutEditMode ? 1 : pointsMoved[0] ? 0.9 : 0.0)
                                    )
                                    .frame(width: layoutEditMode ? 20 : 8)
                                    .position(
                                        x: CGFloat(pointModels[index].position.x) *
                                        geo.size.width,
                                        y: CGFloat(pointModels[index].position.y) *
                                        geo.size.height
                                    )
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                let newX = min(
                                                    max(value.location.x / geo.size.width, 0),
                                                    1
                                                )
                                                let newY = min(
                                                    max(value.location.y / geo.size.height, 0),
                                                    1
                                                )
                                                
                                                pointModels[index].position =
                                                SIMD2<Float>(Float(newX), Float(newY))
                                            }
                                    )
                            }
                        }
                    }
                    .clipShape(.rect(cornerRadius: 30))
                    .background{
                        gradient
                            .clipShape(.rect(cornerRadius: 30))
                            .scaleEffect(x: 1.1, y: 1.05)
                            .blur(radius: 40)
                            .opacity((pointsMoved[1] ? 0.6 : 0.0))
                    }
                    .frame(width: gradientWidth, height: gradientHeight)
                    .scaleEffect(pointsMoved[2] ? 1.02 : 1.0)
                if sheet == nil{
                    Options()
                        .safeAreaPadding(.horizontal, (viewSize.width - gradientWidth) / 1.7)
                        .onGeometryChange(for: CGSize.self, of: { proxy in
                            return proxy.size
                        }, action: { newValue in
                            actionsSize = newValue
                        })
                }
            }
            
        }
        .statusBarHidden()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(.dark)
        .background(.black)
    }
    
    // MARK: - Additional Views
    // (for body)
    
    @ViewBuilder
    func Options() -> some View{
        ScrollView(.horizontal){
            HStack{
                Button {
                    withAnimation(.smooth){
                        randomizePoints()
                    }
                    
                } label: {
                    Image(systemName: "shuffle")
                }
                .buttonStyle(OptionsButton())
                
                Menu {
                    
                    Section("Presets") {
                        ForEach(colorPresets, id: \.self){ preset in
                            Button(preset.name) {
                                withAnimation(.smooth){
                                    colors = preset.colors
                                }
                            }
                        }
                    }
                    
                        Button("Customize", systemImage: "swatchpalette") {
                            withAnimation(.smooth){
                                sheet = .colors
                            }
                        }
                } label: {
                    HStack{
                        Circle()
                            .strokeBorder(AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center), lineWidth: 6)
                            .frame(width: 20, height: 20)
                        Text("Colors")
                    }
                }
                .menuOrder(.fixed)
                .buttonStyle(OptionsButton())
                
                Button {
                    withAnimation(.smooth){
                        layoutEditMode.toggle()
                    }
                } label: {
                    HStack{
                        Image(systemName: "circle.grid.3x3")
                            .frame(width: 20, height: 20)
                        Text("Layout")
                    }
                }
                .buttonStyle(OptionsButton())
                
                
                Button {
                    withAnimation(.smooth){
                        hasGrain.toggle()
                    }
                } label: {
                    HStack{
                            Image("Grain")
                                .resizable()
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                                
                            .frame(width: 20, height: 20)
                        Text("Grain")
                    }
                }
                .buttonStyle(OptionsButton())
            }
        }
        .scrollIndicators(.hidden)
        .opacity(layoutEditMode ? 0 : 1)
        .allowsHitTesting(!layoutEditMode)
        .overlay {
            if layoutEditMode{
                VStack(spacing: 9){
                    Text("Drag Points to Reposition")
                        .font(.footnote)
                    Button("Done") {
                        withAnimation(.smooth){
                            layoutEditMode.toggle()
                        }
                    }
                    .fontWeight(.semibold)
                }
                .transition(.asymmetric(insertion: (.opacity.animation(.smooth.delay(0.5))), removal: .opacity.animation(.smooth(duration: 0.2))))
            }
        }
    }
    
    @ViewBuilder
    func StatusButtons() -> some View {
        GeometryReader { geometry in
            let statusBarHeight = geometry.safeAreaInsets.top
            let threshold = statusBarHeight > 10
            
            HStack(spacing: 0){
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundStyle(Color.white)
                })
                .buttonStyle(StatusButton())
                .frame(maxWidth: .infinity, alignment: threshold ? .center : .leading)
                
                Color.clear
                    .frame(width: threshold ? 125 : nil)
                
                
                Button(action: {
                    gradientData.pointModels = pointModels
                    gradientData.colors = colors
                    gradientData.hasGrain = hasGrain
                    gradientData.hasUserCreated = true
                    onGradientCompleteion()
                }, label: {
                    Text("Done")
                        .foregroundStyle(Color.white)
                })
                .labelsHidden()
                .buttonStyle(StatusButton(active: true))
                .frame(maxWidth: .infinity, alignment: threshold ? .center : .trailing)
            }
            .frame(height: threshold ? statusBarHeight + 4 : 40)
            .edgesIgnoringSafeArea(.all)
            .padding(.horizontal, 15)
            .padding(.top, threshold ? 0 : 15)
        }
    }
    
    // MARK: - Computed Properties
    
    var gradientHeight: CGFloat{
        return viewSize.height - 150  - (sheet == nil ? actionsSize.height : sheetSize.height)
    }
    
    var gradientWidth: CGFloat{
        return viewSize.width * (gradientHeight / viewSize.height)
    }
    
    // MARK: - Functions
    
    func adjustedWidth(forWidth width: CGFloat, originalHeight height: CGFloat, heightReduction: CGFloat) -> CGFloat {
        let newHeight = height - heightReduction
        return width * (newHeight / height)
    }
    
    func randomizePoints() {
        pointsMoved[0] = true
        pointsMoved[1] = true
        withAnimation(.smooth(duration: 0.1)) {
            pointsMoved[2] = true
        }
        let offsetRange: ClosedRange<Float> = -0.05...0.05
        
        pointModels = pointModels.map { model in
            var newPosition = model.position
            
            // Check if the point is along an edge.
            let isOnXEdge = (model.position.x == 0.0 || model.position.x == 1.0)
            let isOnYEdge = (model.position.y == 0.0 || model.position.y == 1.0)
            
            if !isOnXEdge {
                newPosition.x += Float.random(in: offsetRange)
            }
            if !isOnYEdge {
                newPosition.y += Float.random(in: offsetRange)
            }
            
            newPosition.x = min(max(newPosition.x, 0.0), 1.0)
            newPosition.y = min(max(newPosition.y, 0.0), 1.0)
            
            // Return a new model, preserving identity if needed.
            return PointModel(id: model.id, position: newPosition)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.smooth(duration: 1)) {
                pointsMoved[2] = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.smooth(duration: 0.6)) {
                pointsMoved[0] = false
            }
            withAnimation(.smooth(duration: 3)) {
                pointsMoved[1] = false
            }
        }
    }
}

struct OptionsButton: ButtonStyle{
    @State private var pressTimer: Timer?
    @State private var pressDuration: Double = 0
    @State private var isPressing: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        let pressDownAnimation: Animation = .smooth
        let damping: Double = max(6, 25 - (pressDuration * 10))
        var releaseAnimation: Animation {
            return Animation.interpolatingSpring(
                stiffness: 200,
                damping: damping)
        }
        let activeAnimation = isPressing ? pressDownAnimation : releaseAnimation
        
        configuration.label
            .padding(10)
            .padding(.horizontal, 2)
            .background(.background.tertiary)
            .clipShape(Capsule())
            .opacity(isPressed ? 0.7 : 1)
            .animation(activeAnimation){ label in
                label
                    .scaleEffect(isPressing ? 0.9 : 1.0)
            }
            .onChange(of: isPressed) {
                if isPressed {
                    startPressTimer()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        stopPressTimer()
                    }
                }
            }
    }
    
    
    private func startPressTimer() {
        // If already pressing, do nothing
        guard !isPressing else { return }
        isPressing = true
        pressDuration = 0
        pressTimer?.invalidate()
        pressTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            DispatchQueue.main.async {
                pressDuration += 0.02
            }
        }
    }
    
    private func stopPressTimer() {
        // If we weren’t pressing, do nothing
        guard isPressing else { return }
        isPressing = false
        
        // Invalidate timer
        pressTimer?.invalidate()
        pressTimer = nil
    }
}

#Preview {
    @Previewable @EnvironmentObject var gradientData: GradientData
    GradientCreator(gradientData, onGradientCompleteion: {
        print("complete!")
    })
    .environmentObject(BackgroundData())
    .environmentObject(GradientData())
    .environmentObject(EditorData())
}
