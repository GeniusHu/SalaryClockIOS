import SwiftUI

struct DashboardView: View {
    @StateObject private var earningsVM = EarningsViewModel()
    @State private var userSettings = UserDefaultsManager.shared.getUserSettings()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 用户信息卡片
                    userInfoCard
                    // 倒计时视图
                    countdownCard
                    // 收入展示
                    earningsCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: languageButton
            )
        }
    }
    
    private var userInfoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("薪时计")
                    .font(.title2)
                    .bold()
                Text("摸鱼中...")
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(4)
            }
            
            Text(Date().formatted(date: .numeric, time: .standard))
                .font(.title3)
            
            Text("入职时间: \(userSettings.joinDate)")
                .foregroundColor(.secondary)
            
            HStack {
                Text("月薪:")
                Text(userSettings.hideAllMoney ? "****" : "¥\(String(format: "%.2f", userSettings.monthlySalary))")
                    .foregroundColor(.orange)
                Button(action: {
                    var newSettings = userSettings
                    newSettings.hideAllMoney.toggle()
                    UserDefaultsManager.shared.saveUserSettings(newSettings)
                    userSettings = newSettings
                }) {
                    Image(systemName: userSettings.hideAllMoney ? "eye.slash.fill" : "eye.slash")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    private var countdownCard: some View {
        VStack(spacing: 16) {
            Text("距离下次上班还有")
                .font(.headline)
            
            HStack(spacing: 20) {
                TimeBlock(value: "00", unit: "天")
                TimeBlock(value: "08", unit: "时")
                TimeBlock(value: "33", unit: "分")
                TimeBlock(value: "08", unit: "秒")
            }
            
            Text("下次上班时间: 2025/1/17 09:00:00")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    private var earningsCard: some View {
        VStack(spacing: 16) {
            EarningsRow(title: "今日打工已赚", amount: earningsVM.earnings.today, hideAmount: userSettings.hideAllMoney)
            Divider()
            EarningsRow(title: "本月打工已赚", amount: earningsVM.earnings.month, hideAmount: userSettings.hideAllMoney)
            Divider()
            EarningsRow(title: "今年打工已赚", amount: earningsVM.earnings.year, hideAmount: userSettings.hideAllMoney)
            
            // 摸鱼小贴士
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.orange)
                    Text("摸鱼小贴士")
                        .bold()
                }
                
                Text("• 工作再累，也要记得喝水休息")
                    .foregroundColor(.secondary)
                Text("• 合理安排时间，提高工作效率")
                    .foregroundColor(.secondary)
                Text("• 适度摸鱼，保持心情愉悦")
                    .foregroundColor(.secondary)
            }
            .padding(.top)
            
            // 分享按钮
            Button(action: {
                // 分享功能
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("分享给好友")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
            .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
    
    private var languageButton: some View {
        Button(action: {
            // 语言切换
        }) {
            Text("中文")
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)
                .cornerRadius(16)
        }
    }
}

struct EarningsRow: View {
    let title: String
    let amount: Double
    let hideAmount: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            if hideAmount {
                Text("****")
            } else {
                Text("¥\(String(format: "%.2f", amount))")
                    .bold()
                    .foregroundColor(.orange)
            }
            Image(systemName: "eye.slash")
                .foregroundColor(.secondary)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
} 