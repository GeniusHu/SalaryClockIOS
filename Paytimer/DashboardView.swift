import SwiftUI
import Combine

struct DashboardView: View {
    @StateObject private var timerManager: TimerManager
    @State private var userSettings = UserSettings()
    @StateObject private var earningsManager = EarningsManager.shared


    init() {
        _timerManager = StateObject(wrappedValue: TimerManager(userSettings: UserSettings()))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HeaderView(currentTime: $timerManager.currentTime)
                InfoCardView(userSettings: userSettings)
                CountdownCardView()
                EarningsCardView(earningsManager: earningsManager)
                TipsCardView()
                ShareButtonView()

            }
            .padding(.horizontal, 16)
        }
        .background(Color(hex: "#FFD700")) // 背景颜色
        .onAppear {
          timerManager.startTimer() // 页面加载时启动计时器
            let customWorkdays = HolidayManager.shared.loadCustomWorkdays()
                        let currentMonth = Calendar.current.component(.month, from: Date())
                        let currentYear = Calendar.current.component(.year, from: Date())
                        let workdays = earningsManager.incomeCalculator.calculateWorkdays(
                            for: currentMonth,
                            year: currentYear,
                            customWorkdays: customWorkdays
                        )
                        let dailySalary = earningsManager.incomeCalculator.calculateDailySalary(
                            monthlySalary: 20000,
                            workdays: workdays
                        )
            earningsManager.updateTodayEarnings()
        }
        .onDisappear {
            timerManager.stopTimer() // 页面离开时停止计时器
        }
    }
}
