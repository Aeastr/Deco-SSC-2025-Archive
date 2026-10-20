//
//  Onboarding.swift
//  Deco
//
//  Created by Aether on 22/02/2025.
//


import SwiftUI

let cards: [FeatureCard] = [
    .init(image: "card1"),
    .init(image: "card2"),
    .init(image: "card3"),
    .init(image: "card4")
]

struct Onboard: View {
    // MARK: - Focus & Interaction
    @State private var focusedCard: FeatureCard? = cards.first
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = 0
    
    // MARK: - Animations
    @State private var animation: [Bool] = [false, false]
    @State private var featuresAnimation: Bool = false
    @State private var titleProgress: CGFloat = .zero
    
    // MARK: - Scroll Behavior
    @State private var scrollPhase: ScrollPhase = .idle
    
    // MARK: - Timer
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .default).autoconnect()
    
    // MARK: - Binding & Storage
    @Binding var firstLaunch: Bool
    
    var body: some View {
        ZStack{
            Ambience()
                .animation(.smooth(duration: 2), value: focusedCard)
            
            VStack(spacing: 40){
                Carousel()
                    .shadow(color: Color.black.opacity(0.2), radius: 15, y: 2)
                
                VStack(spacing: 15){
                    VStack(spacing: 5){
                        Text("Deco")
                            .font(.largeTitle.weight(.bold))
                            .foregroundStyle(Color.white)
                            .textRenderer(IntroTextRender(progress: titleProgress))
                        
                        Text("Stick it. Love it. Lock it.")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Color.white.secondary)
                            .blurOpacityEffect(animation[0])
                    }
                    
                    Text("Personalize your wallpapers with your own unqiue stickers, colors, gradients and photos.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 20)
                        .blurOpacityEffect(animation[0])
                }
                
                Button("Get Started") {
                    withAnimation(.smooth){
                        firstLaunch = false
                    }
                }
                .buttonStyle(SelectionButton())
                .blurOpacityEffect(animation[1])
            }
            .safeAreaPadding(15)
        }
        .onReceive(timer) { _ in
            currentScrollOffset += 0.35
            scrollPosition.scrollTo(x: currentScrollOffset)
        }
        .task {
            try? await Task.sleep(for: .seconds(0.6))
            withAnimation(.smooth(duration: 2)) {
                titleProgress = 1
            }
            
            try? await Task.sleep(for: .seconds(0.35))
            withAnimation(.smooth(duration: 0.6)) {
                featuresAnimation = true
                animation[0] = true
            }
            try? await Task.sleep(for: .seconds(0.7))
            withAnimation(.smooth(duration: 0.8)) {
                animation[1] = true
            }
        }
    }
    
    @ViewBuilder
    private func Ambience() -> some View{
        GeometryReader {
            let size = $0.size
            ZStack{
                ForEach(cards) { card in
                    Image(card.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .saturation(2)
                        .brightness(0.2)
                        .opacity(focusedCard?.id == card.id ? 1 : 0)
                }
                
                Color.black.opacity(0.5)
            }
            .compositingGroup()
            .blur(radius: 90, opaque: true)
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func Carousel() -> some View{
        
        RepeatingScrollView() {
            ForEach(cards) { card in
                Card(card)
            }
        }
        .scrollIndicators(.hidden)
        .scrollPosition($scrollPosition)
        .containerRelativeFrame(.vertical){ value, _ in
            value * 0.45
        }
        .onScrollPhaseChange{ oldPhase, newPhase in
            scrollPhase = newPhase
        }
        .onScrollGeometryChange(for: CGFloat.self) { proxy in
            return proxy.contentOffset.x + proxy.contentInsets.leading
        } action: { oldValue, newValue in
            currentScrollOffset = newValue
            
            if scrollPhase != .decelerating || scrollPhase != .animating{
                let focusedIndex = Int((currentScrollOffset / 220).rounded()) % cards.count
                focusedCard = cards[focusedIndex]
            }
        }
        .visualEffect { [featuresAnimation] content, proxy in
            content
                .offset(y: !featuresAnimation ? -(proxy.size.height + 200) : 0)
        }
    }
    
    @ViewBuilder
    private func Card(_ card: FeatureCard) -> some View {
        GeometryReader {
            let size = $0.size
            
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipShape(.rect(cornerRadius: 20))
        }
        .frame(width: 220)
        .scrollTransition(.interactive, axis: .horizontal) { content, phase in
            content
                .offset(y: phase == .identity ? -10 : 0)
                .rotationEffect(.degrees(phase.value * 4), anchor: .bottom)
        }
    }
}

#Preview {
    Onboard(firstLaunch: .constant(false))
}

extension View{
    func blurOpacityEffect(_ show: Bool) -> some View {
        self
            .blur(radius: show ? 0 : 2)
            .opacity(show ? 1 : 0)
            .scaleEffect(show ? 1 : 0.9)
    }
}

struct IntroTextRender: TextRenderer, Animatable {
    var progress: CGFloat
    var animatableData: CGFloat{
        get { progress }
        set { progress = newValue }
    }
    
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let slices = layout.flatMap({$0}).flatMap({$0})
        
        for (index, slice) in slices.enumerated(){
            let slicePorgressIndex = CGFloat(slices.count) * progress
            let sliceProgress = max(min(slicePorgressIndex / CGFloat(index + 1), 1), 0)
            
            ctx.addFilter(.blur(radius: 5 - (5 * sliceProgress)))
            ctx.opacity = sliceProgress
            ctx.translateBy(x: 0, y: 5 - (5 * sliceProgress))
            ctx.draw(slice, options: .disablesSubpixelQuantization)
        }
    }
}
