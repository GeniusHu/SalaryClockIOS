import Foundation

class EarningsCalculator {
    static let shared = EarningsCalculator()
    
    private init() {}
    
    func calculateDailyEarnings(salary: Double, workDays: Int) -> Double {
        return salary / Double(workDays)
    }
    
    func calculateCurrentEarnings(dailySalary: Double,
                                startTime: Date,
                                endTime: Date,
                                currentTime: Date) -> Double {
        // 如果不是工作日，返回0
        if !isWorkday(currentTime) {
            return 0
        }
        
        let workDuration = endTime.timeIntervalSince(startTime)
        let workedDuration = currentTime.timeIntervalSince(startTime)
        let ratio = max(0, min(1, workedDuration / workDuration))
        return dailySalary * ratio
    }
    
    func isWorkday(_ date: Date = Date()) -> Bool {
        let settings = UserDefaultsManager.shared.getUserSettings()
        let weekday = Calendar.current.component(.weekday, from: date)
        // 将周日的1转换为7，其他日期减1，以匹配设置中的workDays数组
        let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
        return settings.workDays.contains(adjustedWeekday)
    }
    
    func getWorkDaysInMonth(_ date: Date = Date()) -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        var workDays = 0
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        var components = DateComponents()
        components.year = year
        components.month = month
        
        for day in range {
            components.day = day
            if let date = calendar.date(from: components),
               isWorkday(date) {
                workDays += 1
            }
        }
        
        return workDays
    }
    
    func getWorkDaysInYear(_ date: Date = Date()) -> Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        var totalWorkDays = 0
        
        var components = DateComponents()
        components.year = year
        
        for month in 1...12 {
            components.month = month
            if let monthDate = calendar.date(from: components) {
                totalWorkDays += getWorkDaysInMonth(monthDate)
            }
        }
        
        return totalWorkDays
    }
} 