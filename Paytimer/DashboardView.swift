import SwiftUI

struct DashboardView: View {
    @State private var userSettings = UserDefaultsManager.shared.getUserSettings()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    UserInfoCardView(settings: userSettings)
                        .padding()
                    
                    CountdownView()
                        .padding()
                    
                    EarningsView()
                        .padding()
                }
            }
            .navigationTitle("工作计时")
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
} 