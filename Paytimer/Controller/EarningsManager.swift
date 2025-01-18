import Foundation

/**
 `EarningsManager` 用于封装收入计算的主要逻辑。
 核心思路：
 - 当月薪或月份变更时，调用 `updateMonthlySalary(newSalary:...)` 来一次性计算并存储 `dailySalary`。
 - 之后，每当需要获取今日或当月的收入时，就使用存好的 `dailySalary` 做简单运算即可，无需反复遍历计算。
 */
class EarningsManager {
    
    // MARK: - 单例
    static let shared = EarningsManager()
    
    // MARK: - 关键属性
    
    /// 存储当前计算出来的“日薪”。
    /// 只在 `updateMonthlySalary(...)` 里更新一次，避免每次刷新都要计算。
    private(set) var dailySalary: Double = 0.0
    
    /// 也可以选择存储“月薪”到这个类里，看你需要。这里演示存一下，以便计算全年收入等。
    private(set) var monthlySalary: Double = 0.0
    
    // MARK: - 私有初始化（单例）
    private init() {}
    
    // MARK: - 1. 更新月薪并重新计算日薪
    
    /**
     更新月薪并重新计算“日薪”。
     
     - parameter newSalary: 新的月薪
     - parameter date: 当前参考的时间（一般传 `Date()` 表示当月）
     - parameter holidayManager: 用于判断实际工作日、节假日
     - parameter customWorkdays: 用户自定义的工作日数组 [周一=0, ..., 周日=6]
     
     在此方法中，会先算出“当月总实际工作日数”，再将 `newSalary` 除以该天数，保存到 `dailySalary`。
     
     这个方法可在：
        1. 用户修改月薪时调用
        2. 每月进入新月份时重新调用（因为当月工作日数可能变了）
     */
    func updateMonthlySalary(
        newSalary: Double,
        for date: Date,
        holidayManager: HolidayManager,
        customWorkdays: [Bool]
    ) {
        self.monthlySalary = newSalary
        
        // 1. 计算“这个月”的总工作日数
        let totalWorkDays = getWorkingDaysCountOfMonth(
            date: date,
            holidayManager: holidayManager,
            customWorkdays: customWorkdays
        )
        
        // 2. 求日薪
        guard totalWorkDays > 0 else {
            // 若整月都休息(或节假日)，则日薪=0
            self.dailySalary = 0
            return
        }
        
        let dSalary = newSalary / Double(totalWorkDays)
        self.dailySalary = dSalary
    }
    
    // MARK: - 2. 计算今天到此刻的收入
    
    /**
     计算“今天到此刻”为止，已经获得的收入（基于已有的 `dailySalary`）。
     
     - parameter now: 当前时间
     - parameter workStartTime: 当天上班时间
     - parameter workEndTime: 当天下班时间
     - parameter isTodayWorkday: 今天是否工作日
     
     返回：若今天是工作日，则按“工作时长占比”乘以日薪；如果今天非工作日则为 0；若已过下班，则等于日薪。
     
     你可以在定时器里或其他地方，每次刷新时调用这个方法。
     */
    func calculateTodayEarningsSoFar(
        now: Date,
        workStartTime: Date,
        workEndTime: Date,
        isTodayWorkday: Bool
    ) -> Double {
        // 如果不是工作日，则今天收入为 0
        if !isTodayWorkday {
            return 0
        }
        
        // 如果日薪 = 0（说明可能整月没工作日或还没更新），就直接返回 0
        if dailySalary <= 0 {
            return 0
        }
        
        // 确保 start < end
        guard workStartTime < workEndTime else {
            return 0
        }
        
        // 情况1：还没到上班时间
        if now < workStartTime {
            return 0
        }
        
        // 情况2：已过下班时间，今日收入已满=日薪
        if now >= workEndTime {
            return dailySalary
        }
        
        // 情况3：正在上班时间范围内
        let totalWorkSeconds = workEndTime.timeIntervalSince(workStartTime)
        let workedSeconds = now.timeIntervalSince(workStartTime)
        
        let fraction = workedSeconds / totalWorkSeconds
        let partialEarnings = dailySalary * fraction
        return partialEarnings
    }
    
    // MARK: - 3. 计算本月到当前时刻的累计收入
    
    /**
     计算“本月到此刻”为止的累计收入：
     = [之前已经完整结束的工作日 * 日薪] + [如果今天是工作日，则加上今天已经工作的部分]
     
     - parameter now: 当前时间
     - parameter holidayManager: 用于判断某天是否工作日
     - parameter customWorkdays: 用户自定义一周哪些天是工作日
     - parameter workStartTime: 今日上班时间
     - parameter workEndTime: 今日下班时间
     
     - returns: 截至 now 的本月累计收入（基于当前 `dailySalary`）
     
     在调用此方法前，记得先保证已经调用过 `updateMonthlySalary`，并且 `dailySalary` 已正确计算过。
     */
    func calculateThisMonthEarningsSoFar(
        now: Date,
        holidayManager: HolidayManager,
        customWorkdays: [Bool],
        workStartTime: Date,
        workEndTime: Date
    ) -> Double {
        // 如果 dailySalary 还没算好，直接返回 0
        if dailySalary <= 0 {
            return 0
        }
        
        // 1. 先算出当月已完成（不含今天）的工作日数
        let completedDays = getCompletedWorkingDaysBefore(
            date: now,
            holidayManager: holidayManager,
            customWorkdays: customWorkdays
        )
        let fullDaysEarnings = Double(completedDays) * dailySalary
        
        // 2. 再算“今天”是否工作日、已工作多少
        let isTodayWorkday = holidayManager.isWorkday(date: now, customWorkdays: customWorkdays)
        let todaySoFar = calculateTodayEarningsSoFar(
            now: now,
            workStartTime: workStartTime,
            workEndTime: workEndTime,
            isTodayWorkday: isTodayWorkday
        )
        
        return fullDaysEarnings + todaySoFar
    }
    
    // MARK: - 4. 其他辅助，比如“全年收入”等
    
    /**
     计算全年收入（简单起见：月薪*12），或根据 business 需求另行实现。
     */
    func calculateYearlyEarnings() -> Double {
        return monthlySalary * 12
    }
    
    // MARK: - 私有/辅助方法
    
    /**
     计算指定 `date` 所在月份的总工作日数（排除法定节假日、用户自定义休息日）。
     */
    private func getWorkingDaysCountOfMonth(
        date: Date,
        holidayManager: HolidayManager,
        customWorkdays: [Bool]
    ) -> Int {
        let calendar = Calendar.current
        
        // 当月1号
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return 0
        }
        // 下个月1号，再减一天就是本月末
        guard let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth),
              let endOfMonth = calendar.date(byAdding: .day, value: -1, to: startOfNextMonth) else {
            return 0
        }
        
        var count = 0
        var currentDay = startOfMonth
        while currentDay <= endOfMonth {
            if holidayManager.isWorkday(date: currentDay, customWorkdays: customWorkdays) {
                count += 1
            }
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDay) else {
                break
            }
            currentDay = nextDay
        }
        return count
    }
    
    /**
     计算当月1号到“昨天”为止，已经完整结束的工作日数（不含今天）。
     */
    private func getCompletedWorkingDaysBefore(
        date: Date,
        holidayManager: HolidayManager,
        customWorkdays: [Bool]
    ) -> Int {
        let calendar = Calendar.current
        
        // 当月1号
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return 0
        }
        
        // 今天的零点
        let startOfToday = calendar.startOfDay(for: date)
        
        var count = 0
        var currentDay = startOfMonth
        
        while currentDay < startOfToday {
            if holidayManager.isWorkday(date: currentDay, customWorkdays: customWorkdays) {
                count += 1
            }
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDay) else {
                break
            }
            currentDay = nextDay
        }
        return count
    }
}
