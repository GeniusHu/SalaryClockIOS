import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label(NSLocalizedString("dashboard.title", comment: ""), systemImage: "house.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label(NSLocalizedString("settings.title", comment: ""), systemImage: "gearshape.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
