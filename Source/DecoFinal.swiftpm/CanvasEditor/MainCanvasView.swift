import SwiftUI

enum CanvasViewMode {
    case edit
    //    case layers
    case preview
    case export
}

struct MainCanvasView: View {
    // MARK: - Environment Objects
    @EnvironmentObject var backgroundData: BackgroundData
    @EnvironmentObject var editorData: EditorData
    
    // MARK: - State Variables
    @State var showWallpaperGallery: Bool = false
    @State var bgSize: CGSize = .zero
    @State private var selectedStickerId: UUID? = nil
    @State private var showStickerSheet: Bool = true
    @State private var stickerSheetHeight: CGFloat = .zero
    @State var gotSize: Bool = false
    
    // MARK: - Bindings
    @Binding var safeArea: EdgeInsets?
    @State var canvasViewMode: CanvasViewMode
    @Binding var showExport: Bool
    
    // MARK: - View Properties
    var viewSize: CGSize
    
    // MARK: - Actions
    func addSticker(template: Sticker) {
        let newSticker = PlacedSticker(template: template, position: CGSize(width: 0, height: 0))
        editorData.placedStickers.append(newSticker)
        selectedStickerId = newSticker.id
    }
    
    init(safeArea: Binding<EdgeInsets?>, showExport: Binding<Bool> = .constant(false), viewSize: CGSize, overrideMode: CanvasViewMode? = nil){
        self._safeArea = safeArea
        self._showExport = showExport
        self.viewSize = viewSize
        if let overrideMode{
            self._canvasViewMode = .init(initialValue: overrideMode)
        }
        else{
            self._canvasViewMode = .init(initialValue: .edit)
        }
    }
    
    // MARK: - Main Layers
    var stickerLayer: some View{
        ForEach($editorData.placedStickers) { $placed in
            InteractiveStickerView(
                id: placed.id,
                sticker: $placed,
                selectedStickerId: $selectedStickerId,
                onRemove: {
                    if let index = editorData.placedStickers.firstIndex(where: { $0.id == placed.id }) {
                        editorData.placedStickers.remove(at: index)
                    }
                }
            )
            .transition(.asymmetric(insertion: .scale(scale: 1.8, anchor: .top).combined(with: .opacity).animation(.bouncy), removal: .opacity.animation(.snappy(duration: 0.2))))
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 1.5)
            .zIndex(placed.background ? 1 : 3)
        }
        .ignoresSafeArea()
        .frame(width: min(viewSize.width, viewSize.height), height: min(viewSize.width, viewSize.height))
        .padding(.top, canvasViewMode == .export ? safeArea?.top ?? 0 : 0)
        .padding(.bottom, canvasViewMode == .export ? safeArea?.bottom ?? 0 : 0)
    }
    var background: some View{
        BackgroundView()
            .onTapGesture {
                print("tap bg")
                selectedStickerId = nil
            }
            .ignoresSafeArea()
            .onLongPressGesture(minimumDuration: 0.5) {
                withAnimation(.snappy(duration: 0.3)) {
                    canvasViewMode = .preview
                }
            } onPressingChanged: { Bool in
                canvasViewMode = .edit
            }
            .zIndex(0)
    }
    var backgroundSubject: some View{
        PhotoBackgroundSegment()
            .ignoresSafeArea()
            .opacity(canvasViewMode == .export ? 1 : selectedStickerId != nil ? 0.7 : 0.9)
            .allowsHitTesting(false)
            .zIndex(2)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            LSClock(large: safeArea?.top ?? 0 < 10 ? true : false)
                            .zIndex(0)
                            .opacity(canvasViewMode == .export ? 0 : 1)
            
            stickerLayer
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if backgroundData.type == .photo && backgroundData.depthEffect{
                backgroundSubject
                    .frame(width: viewSize.width, height: viewSize.height, alignment: .center)
                    .ignoresSafeArea()
                    .frame(width: min(viewSize.width, viewSize.height), height: min(viewSize.width, viewSize.height))
                    .frame(maxHeight: .infinity, alignment: .center)
                // easier to handle as a square view, super hacky, other methods kept failing (positions, overlays, etc ): )
            }
        
                StatusButtons()
                    .dynamicTypeSize(.xLarge...DynamicTypeSize.xxxLarge)
                    .opacity([.preview, .export].contains(canvasViewMode) ? 0 : 1)
                    .zIndex(4)
            
        }
        .background{
            background
                .frame(width: viewSize.width, height: viewSize.height, alignment: .center)
                .ignoresSafeArea()
                .frame(width: min(viewSize.width, viewSize.height), height: min(viewSize.width, viewSize.height))
                .frame(maxHeight: .infinity, alignment: .center)
        }
            .overlay(alignment: .bottom, content: {
                EditorActions(showStickerSheet: $showStickerSheet, stickerSheetHeight: $stickerSheetHeight, canvasViewMode: $canvasViewMode)
            })
            .sheet(isPresented: $showStickerSheet) {
                StickerSheet()
            }
            .sheet(isPresented: $showWallpaperGallery, content: {
                BackgroundSelector()
                    .background(Color.black.ignoresSafeArea())
                    .presentationCornerRadius(30)
            })
            .background{
                Color.black
                    .ignoresSafeArea()
            }
    }
    
    // MARK: - Supporting Views
    @ViewBuilder
    func StickerSheet() -> some View{
        StickerPicker(stickers: sampleStickers, onStickerSelected: { sticker in
            withAnimation(.snappy){
                if showStickerSheet{
                    stickerSheetHeight = .zero
                }
                showStickerSheet.toggle()
            }
            addSticker(template: sticker)
        })
        .presentationDetents(
            [.fraction(0.4), .fraction(0.998)]
        )
        .onGeometryChange(for: CGFloat.self, of: { GeometryProxy in
            return GeometryProxy.size.height
        }, action: { newValue in
            print(newValue)
            if showStickerSheet{
                stickerSheetHeight = newValue
            }
        })
        .onDisappear(){
            stickerSheetHeight = .zero
        }
        .presentationBackground(Material.thick)
        .presentationBackgroundInteraction(.enabled)
        .presentationCornerRadius(30)
    }
    
    @ViewBuilder
    func StatusButtons() -> some View {
        GeometryReader { geometry in
            let statusBarHeight = geometry.safeAreaInsets.top
            let threshold = statusBarHeight > 10
            
            HStack(spacing: 0){
                
                Button("Change", action: {
                    showStickerSheet = false
                    showWallpaperGallery.toggle()
                })
                .buttonStyle(StatusButton())
                .frame(maxWidth: .infinity, alignment: threshold ? .center : .leading)
                
                Color.clear
                    .frame(width: threshold ? 125 : nil)
                
                
                Button(action: {
                    showWallpaperGallery = false
                    showStickerSheet = false
                    showExport.toggle()
                }, label: {
                    Text("Export")
                })
                .labelsHidden()
                .buttonStyle(StatusButton())
                .frame(maxWidth: .infinity, alignment: threshold ? .center : .trailing)
            }
            .frame(height: threshold ? statusBarHeight + 4 : 40)
            .edgesIgnoringSafeArea(.all)
            .padding(.horizontal, 15)
            .padding(.top, threshold ? 0 : 15)
        }
    }
    
    // MARK: - Stickers
    let sampleStickers: [Sticker] = [
        Sticker(
            name: "Rainbow Hello",
            isText: false,
            content: AnyView(
                Image("hello")
                    .resizable()
                    .scaledToFit()
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Heart",
            content: AnyView(
                Text("❤️")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Rocket",
            content: AnyView(
                Text("🚀")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Books",
            content: AnyView(
                Text("📚")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Sparkles",
            content: AnyView(
                Text("✨")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Thumbs Up",
            content: AnyView(
                Text("👍")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Wink",
            content: AnyView(
                Text("😉")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Shrug",
            content: AnyView(
                Text("🤷‍♀️")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Look of Disapproval",
            content: AnyView(
                Text("ಠ_ಠ")
                    .font(.system(size: 50))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Sleeping",
            content: AnyView(
                Text("(-_-)zzz")
                    .font(.system(size: 50))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Confused",
            content: AnyView(
                Text("(⊙_⊙)")
                    .font(.system(size: 50))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Bear",
            content: AnyView(
                Text("ʕ•́ᴥ•̀ʔっ")
                    .font(.system(size: 40))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Deal With It",
            content: AnyView(
                Text("(⌐■_■)")
                    .font(.system(size: 50))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Crying",
            content: AnyView(
                Text("｡ﾟ(ﾟ´Д｀ﾟ)ﾟ｡")
                    .font(.system(size: 40))
                    .lineLimit(1)
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Robot",
            content: AnyView(
                Text("🤖")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Thinking Face",
            content: AnyView(
                Text("🤔")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Star-Struck",
            content: AnyView(
                Text("🤩")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Partying Face",
            content: AnyView(
                Text("🥳")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Melting Face",
            content: AnyView(
                Text("🫠")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
        Sticker(
            name: "Freezing Face",
            content: AnyView(
                Text("🥶")
                    .font(.system(size: 70))
                    .modifier(TypicalSticker())
            )
        ),
    ]
}
