import SwiftUI
struct DashboardView: View {
    @State private var currentTime = Date()
    @State private var earnings = Earnings(today: 2000, month: 5000, year: 10000)
    @State private var userSettings = UserSettings()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HeaderView(currentTime: $currentTime)
                InfoCardView(userSettings: userSettings)
                CountdownCardView(workEndTime: userSettings.workEndTime)
                EarningsCardView(earnings: earnings)
                TipsCardView()
                ShareButtonView()
            }
            .padding(.horizontal, 16)
        }
        .background(Color(hex: "#FFD700")) // 卡片背景颜色
    }


    private func updateEarnings() {
        guard let startTime = userSettings.workStartTime.toDate(),
              let endTime = userSettings.workEndTime.toDate() else { return }
        let dailySalary = calculateDailyEarnings(salary: userSettings.monthlySalary, workDays: userSettings.workDays.count)
        earnings.today = calculateCurrentEarnings(dailySalary: dailySalary, startTime: startTime, endTime: endTime, currentTime: Date())
    }
}
