import Foundation

class EarningsCalculator {
    static let shared = EarningsCalculator()
    
    func calculateDailyEarnings(salary: Double, workDays: Int) -> Double {
        return salary / Double(workDays)
    }
    
    func calculateCurrentEarnings(dailySalary: Double,
                                startTime: Date,
                                endTime: Date,
                                currentTime: Date) -> Double {
        let workDuration = endTime.timeIntervalSince(startTime)
        let workedDuration = currentTime.timeIntervalSince(startTime)
        let ratio = max(0, min(1, workedDuration / workDuration))
        return dailySalary * ratio
    }
} 