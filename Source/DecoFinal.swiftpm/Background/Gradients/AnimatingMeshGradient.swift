import SwiftUI
import simd


struct AnimatingMeshGradient: View {
    // MARK: - Environment
    @EnvironmentObject var gradientData: GradientData
    
    // MARK: - State
    @State private var startTime: TimeInterval =
    Date().timeIntervalSinceReferenceDate
    
    // MARK: - Gradient Attributes
    private let basePoints: [SIMD2<Float>] = [
        [0.0, 0.0],  [0.33, 0.0],  [0.66, 0.0],  [1.0, 0.0],
        [0.0, 0.4],  [0.33, 0.4], [0.66, 0.4], [1.0, 0.4],
        [0.0, 0.8],  [0.33, 0.8], [0.66, 0.8],  [1.0, 0.8],
        [0.0, 1.0],  [0.33, 1.0],  [0.66, 1.0],  [1.0, 1.0]
    ]
    let baseColors: [Color]
    
    // MARK: - Initalizer
    
    init(_ colors: [Color]? = nil){
        self.baseColors = colors ?? [
            Color(red: 0.75, green: 0.8, blue: 0.85),
            Color(red: 0.6, green: 0.7, blue: 0.8),
            Color(red: 0.45, green: 0.6, blue: 0.75),
            Color(red: 0.3, green: 0.5, blue: 0.7),
            Color(red: 0.95, green: 0.95, blue: 1.0),
            Color(red: 0.9, green: 0.9, blue: 0.95),
            Color(red: 0.8, green: 0.8, blue: 0.9),
            Color(red: 0.65, green: 0.6, blue: 0.8),
            Color(red: 0.5, green: 0.45, blue: 0.7),
            Color(red: 0.4, green: 0.35, blue: 0.6),
            Color(red: 0.25, green: 0.2, blue: 0.45),
            Color(red: 0.9, green: 0.85, blue: 0.95),
            Color(red: 0.8, green: 0.75, blue: 0.9),
            Color(red: 0.6, green: 0.55, blue: 0.75),
            Color(red: 0.3, green: 0.4, blue: 0.6),
            Color(red: 0.95, green: 0.9, blue: 0.85)
        ]
    }
    
    // MARK: - Body
    var body: some View {
        TimelineView(.animation) { timeline in
            let now = timeline.date.timeIntervalSinceReferenceDate
            let relativeTime = now - startTime
            let phase = now.truncatingRemainder(dividingBy: 2 * .pi)
            
            // animate points in a oscilating pattern
            let animatedPoints = basePoints.map { point in
                adjustedPoint(point: point, relativeTime: relativeTime)
            }
            
            // create colors by modulating each base color slightly
            let animatedColors = baseColors.enumerated().map { index, color in
                color.modulate(with: 0.2,
                               phase: phase,
                               offset: Double(index) * 0.5)
            }
            
            MeshGradient(
                width: 4,
                height: 4,
                points: animatedPoints,
                colors: animatedColors
            )
            .overlay {
                if gradientData.hasGrain{
                    Image("Grain")
                        .resizable()
                        .opacity(0.5)
                }
            }
            .ignoresSafeArea()
            
        }
    }
    
    // MARK: - Functions
    
    func adjustedPoint(point: SIMD2<Float>, relativeTime time: TimeInterval) -> SIMD2<Float> {
        let t = Float(time)
        
        // oscillation parameters
        let amplitude: Float = 0.2
        let frequency: Float = 0.1
        
        // random-ness parameters
        let noiseAmplitude: Float = 0.02
        let noiseFrequency: Float = 0.5
        
        // get new x and y for point
       
        let mainOscillationX = sin(frequency * t + point.x * .pi)
        let mainOscillationY = cos(frequency * t + point.y * .pi)
        
        let randomOffsetX = noiseAmplitude * sin(noiseFrequency * t * 1.7 + point.y * 3.14) * mainOscillationX
        let randomOffsetY = noiseAmplitude * cos(noiseFrequency * t * 2.3 + point.x * 2.71) * mainOscillationY
        
        let offsetX = amplitude * mainOscillationX + randomOffsetX
        let offsetY = amplitude * mainOscillationY + randomOffsetY
        
        // apply changes
        
        var newX = point.x
        var newY = point.y
        
        
        let tolerance: Float = 0.001
        
        // constrain movement depending on the edge
        // moving edge points too buggy..
        if abs(point.y - 0.0) < tolerance || abs(point.y - 1.0) < tolerance {
            // top/bottom edge - move horizontally only
            // newX += offsetX
        } else if abs(point.x - 0.0) < tolerance || abs(point.x - 1.0) < tolerance {
            // left/right edge - move vertically only
            // newY += offsetY
        } else {
            // interior point - adjust both directions with added randomness
            newX += offsetX
            newY += offsetY
        }
        
        // clamp the result between 0 and 1
        newX = min(max(newX, 0), 1)
        newY = min(max(newY, 0), 1)
        
        return SIMD2<Float>(newX, newY)
    }
}

#Preview{
    AnimatingMeshGradient()
        .environmentObject(BackgroundData())
        .environmentObject(GradientData())
        .environmentObject(EditorData())
}

