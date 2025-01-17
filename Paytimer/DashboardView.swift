import SwiftUI
import Combine

struct DashboardView: View {
    @StateObject private var timerManager: TimerManager
    @State private var userSettings = UserSettings()

    init() {
        _timerManager = StateObject(wrappedValue: TimerManager(userSettings: UserSettings()))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HeaderView(currentTime: $timerManager.currentTime)
                InfoCardView(userSettings: userSettings)
                CountdownCardView()
                EarningsCardView(earnings: timerManager.earnings)
                TipsCardView()
                ShareButtonView()
            }
            .padding(.horizontal, 16)
        }
        .background(Color(hex: "#FFD700")) // 背景颜色
        .onAppear {
            timerManager.startTimer() // 页面加载时启动计时器
        }
        .onDisappear {
            timerManager.stopTimer() // 页面离开时停止计时器
        }
    }
}
