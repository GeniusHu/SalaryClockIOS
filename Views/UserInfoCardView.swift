import SwiftUI

struct UserInfoCardView: View {
    let settings: UserSettings
    @State private var currentTime = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("当前时间：\(currentTime.formatted())")
            Text("入职时间：\(settings.joinDate)")
            Text("月薪：\(settings.hideAllMoney ? "****" : String(format: "¥%.2f", settings.monthlySalary))")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .onReceive(timer) { time in
            currentTime = time
        }
    }
}

struct UserInfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoCardView(settings: .default)
            .padding()
            .previewLayout(.sizeThatFits)
    }
} 