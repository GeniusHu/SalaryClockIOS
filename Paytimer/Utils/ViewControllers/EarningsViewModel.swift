import Foundation
import Combine

class EarningsViewModel: ObservableObject {
    @Published var earnings = Earnings.zero
    private var timer: Timer?
    private let calculator = EarningsCalculator.shared
    
    init() {
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateEarnings()
        }
    }
    
    private func updateEarnings() {
        let settings = UserDefaultsManager.shared.getUserSettings()
        let workDaysInMonth = calculator.getWorkDaysInMonth()
        let dailySalary = calculator.calculateDailyEarnings(
            salary: settings.monthlySalary,
            workDays: workDaysInMonth
        )
        
        // 计算今日收入
        let now = Date()
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.year, .month, .day], from: now)
        var endComponents = startComponents
        
        startComponents.hour = Int(settings.workStartTime.prefix(2)) ?? 9
        endComponents.hour = Int(settings.workEndTime.prefix(2)) ?? 18
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
        
        // 计算本月收入
        let dayOfMonth = calendar.component(.day, from: now)
        let totalWorkDays = min(dayOfMonth, workDaysInMonth)
        let monthProgress = Double(totalWorkDays) / Double(workDaysInMonth)
        earnings.month = settings.monthlySalary * monthProgress
        
        // 计算今年收入
        let monthOfYear = calendar.component(.month, from: now)
        let yearProgress = Double(monthOfYear) / 12.0
        earnings.year = settings.monthlySalary * 12 * yearProgress
    }
} 