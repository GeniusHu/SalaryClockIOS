import SwiftUI

@main
struct PaytimerApp: App {
    @AppStorage(UserDefaultsKeys.themeMode) private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
