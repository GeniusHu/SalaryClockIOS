import SwiftUI

struct DashboardView: View {
    @ObservedObject private var appData = AppDataManager.shared
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasShownOnboarding")

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 头部：显示当前时间、设置按钮
                HeaderView()

                // 信息卡片
                InfoCardView()

                // 倒计时卡片
                CountdownCardView()

                // 收入卡片
                EarningsCardView()

                // 提示卡片
                TipsCardView()

                // 分享按钮
                ShareButtonView()
            }
            .padding(.horizontal, 16)
        }
        .background(Color(hex: "#FFD700")) // 整体背景
        .onAppear {
            // 界面出现时，启动定时器
            appData.startTimer()
        }
        .onDisappear {
            // 界面离开时，停止定时器（可按需求决定）
            appData.stopTimer()
        }
        .overlay(Group {
            if showOnboarding {
                OnboardingOverlayView(isVisible: $showOnboarding)
            }
        })
    }
}
