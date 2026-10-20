import SwiftUI

@main
struct MyApp: App {
    @StateObject var backgroundData: BackgroundData = BackgroundData()
    @StateObject var editorData: EditorData = EditorData()
    @StateObject var gradientData: GradientData = GradientData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(backgroundData)
                .environment(gradientData)
                .environment(editorData)
                .statusBarHidden()
                
        }
    }
}
