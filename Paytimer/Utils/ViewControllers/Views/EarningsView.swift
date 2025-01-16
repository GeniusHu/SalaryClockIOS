import SwiftUI

struct EarningsView: View {
    @State private var earnings = Earnings.zero
    @State private var hideAmount = false
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 16) {
            EarningsRow(
                title: "今日收入",
                amount: earnings.today,
                hideAmount: hideAmount
            )
            
            Divider()
            
            EarningsRow(
                title: "本月收入",
                amount: earnings.month,
                hideAmount: hideAmount
            )
            
            Divider()
            
            EarningsRow(
                title: "今年收入",
                amount: earnings.year,
                hideAmount: hideAmount
            )
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .onReceive(timer) { _ in
            updateEarnings()
        }
    }
    
    private func updateEarnings() {
        let settings = UserDefaultsManager.shared.getUserSettings()
        hideAmount = settings.hideAllMoney
        
        // TODO: 实现具体的收入计算逻辑
        let calculator = EarningsCalculator.shared
        let dailySalary = calculator.calculateDailyEarnings(
            salary: settings.monthlySalary,
            workDays: 22 // 假设每月22个工作日
        )
        
        // 简单计算当天工作时长比例
        let now = Date()
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.year, .month, .day], from: now)
        var endComponents = startComponents
        
        startComponents.hour = 9  // 上班时间9:00
        endComponents.hour = 18   // 下班时间18:00
        startComponents.minute = 0
        endComponents.minute = 0
        
        if let startTime = calendar.date(from: startComponents),
           let endTime = calendar.date(from: endComponents) {
            earnings.today = calculator.calculateCurrentEarnings(
                dailySalary: dailySalary,
                startTime: startTime,
                endTime: endTime,
                currentTime: now
            )
        }
        
        // 简单计算月收入和年收入
        let monthProgress = Double(calendar.component(.day, from: now)) / 30.0
        earnings.month = settings.monthlySalary * monthProgress
        
        let yearProgress = Double(calendar.component(.month, from: now)) / 12.0
        earnings.year = settings.monthlySalary * 12 * yearProgress
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
            Text(hideAmount ? "****" : String(format: "¥%.2f", amount))
                .bold()
        }
    }
}

struct EarningsView_Previews: PreviewProvider {
    static var previews: some View {
        EarningsView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
} 