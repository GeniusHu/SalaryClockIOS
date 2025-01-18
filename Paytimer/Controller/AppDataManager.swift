import Foundation
import Combine
import SwiftUI

/**
 全局数据管理器，负责：
 - 维护与 UI 绑定的属性（当前时间、倒计时、收入、用户设置等）
 - 通过定时器实时刷新“当前时间”、并更新“倒计时”和“收入”信息
 - 提供对外的接口方法，供设置界面更改月薪、上下班时间、自定义工作日、入职时间等
 */
class AppDataManager: ObservableObject {
    
    // MARK: - 单例
    static let shared = AppDataManager()
    
    // MARK: - 引用其他管理器
    
    /// 节假日 / 工作日等管理器
    let holidayManager = HolidayManager.shared
    
    // MARK: - 发布属性（UI需要监听）

    /// 当前时间（由定时器驱动，每秒刷新）
    @Published var currentTime: Date = Date()
    
    /// 目标时间（可能是“下班时间”或“下一次上班时间”）
    @Published var targetTime: Date = Date()
    
    /// 倒计时的文案，如“距离下班还有”或“距离上班还有”
    @Published var displayText: String = "距离下班还有"
    
    /// 倒计时的天、时、分、秒（在 `CountdownCardView` 用到）
    @Published var days: String = "00"
    @Published var hours: String = "00"
    @Published var minutes: String = "00"
    @Published var seconds: String = "00"
    
    /// 今日收入、本月收入、全年收入
    @Published var todayEarnings: Double = 0.0
    @Published var monthlyEarnings: Double = 0.0
    @Published var yearlyEarnings: Double = 0.0
    
    // MARK: - 用户设置
    
    /// 入职日期
    @Published var joinDate: Date = Date()
    
    /// 月薪
    @Published var monthlySalary: Double = 10000.0
    
    /// 上班时间
    @Published var workStartTime: Date = Date()
    /// 下班时间
    @Published var workEndTime: Date = Date()
    
    /// 自定义工作日 (周一~周日: true=上班, false=休息)
    @Published var customWorkdays: [Bool] = [true, true, true, true, true, false, false]
    
    /// 是否隐藏所有金额
    @Published var hideAllAmounts: Bool = false
    
    // MARK: - 定时器
    private var timer: Timer?
    
    // MARK: - 初始化
    private init() {
        // 从本地加载已有的设置（示例只做简单处理，实际可根据需求完善）
        loadFromStorage()
        
        // 初始化一些默认值，如果加载不到的话
        if workStartTime == Date() {
            // 给个默认 9:00
            workStartTime = makeTodayDate(hour: 9, minute: 0)
        }
        if workEndTime == Date() {
            // 给个默认 18:00
            workEndTime = makeTodayDate(hour: 18, minute: 0)
        }
        
        // 设置 holidayManager 里自定义工作日为当前设置
        holidayManager.saveCustomWorkdays(workdays: customWorkdays)
        
        // 初始化目标时间 + 收入
        updateEarningsAndTargetTime()
    }
    
    // MARK: - 定时器控制
    
    /// 开始计时，每秒刷新一次
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = Date()
            self.updateEarningsAndTargetTime()
        }
    }
    
    /// 停止计时
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - 收入 & 倒计时 更新
    
    /**
     综合更新收入和倒计时
     （在定时器、或用户更改设置后调用）
     */
    func updateEarningsAndTargetTime() {
        // 1. 更新倒计时相关
        updateCountdown()
        
        // 2. 计算今日、本月、全年收入
        //    —— 在此根据工作日/节假日等进行计算
        //    你可以接入 EarningsManager，也可在这里直接写逻辑
        updateEarnings()
    }
    
    /**
     更新倒计时：
     1. 判断当前是否在上班时间内、还是下班后？
     2. 设置 targetTime、displayText
     3. 根据 currentTime vs targetTime 算出天/时/分/秒
     */
    private func updateCountdown() {
        let now = currentTime
        
        // 先判断今天是否工作日
        let isTodayWork = holidayManager.isWorkday(date: now, customWorkdays: customWorkdays)
        
        // 简单示例：如果现在 < workStartTime，则目标是“今日workStartTime”，文本=“距离上班还有”
        // 如果现在在工作时间内，则目标=“今日workEndTime”
        // 如果今天是休息日或已过下班，则看下一工作日9:00
        if isTodayWork {
            if now < workStartTime {
                // 还没上班
                targetTime = workStartTime
                displayText = "距离上班时间还有"
            } else if now >= workStartTime && now < workEndTime {
                // 上班中
                targetTime = workEndTime
                displayText = "距离下班时间还有"
            } else {
                // 已下班，找下一个工作日
                if let nextDay = holidayManager.nextWorkday(from: now.addingTimeInterval(86400)) {
                    targetTime = makeDateSameDayAs(nextDay, hourAndMinuteFrom: workStartTime)
                    displayText = "距离下次上班还有"
                } else {
                    // 极端情况：未来全是休息日
                    targetTime = now
                    displayText = "没有下次上班啦"
                }
            }
        } else {
            // 如果今天是休息日
            if let nextDay = holidayManager.nextWorkday(from: now) {
                targetTime = makeDateSameDayAs(nextDay, hourAndMinuteFrom: workStartTime)
                displayText = "距离下次上班还有"
            } else {
                // 一年内都没工作日
                targetTime = now
                displayText = "没有下次上班啦"
            }
        }
        
        // 计算剩余秒数
        let diff = targetTime.timeIntervalSince(now)
        if diff <= 0 {
            // 已经过了目标时间
            days = "00"
            hours = "00"
            minutes = "00"
            seconds = "00"
            return
        }
        
        // 换算成 天/时/分/秒
        let totalSec = Int(diff)
        let d = totalSec / 86400
        let h = (totalSec % 86400) / 3600
        let m = (totalSec % 3600) / 60
        let s = totalSec % 60
        
        days    = String(format: "%02d", d)
        hours   = String(format: "%02d", h)
        minutes = String(format: "%02d", m)
        seconds = String(format: "%02d", s)
    }
    
    /**
     更新“今日收入”、“本月收入”、“全年收入”示例逻辑
     你可以用 EarningsManager 的算法，或简单自行写
     */
    private func updateEarnings() {
        // 这里只是做一个极简示例：
        //   今日收入 = (月薪 / 22) * 工作时长比例
        //   本月收入 = ...
        //   全年收入 = 月薪 * 12
        
        // 你可将“是否工作日、workedSeconds”等逻辑从 HolidayManager/EarningsManager 获取
        
        // 简化：全年收入
        yearlyEarnings = monthlySalary * 12
        
        // 简化：本月收入 - 这里随便给个估值
        monthlyEarnings = monthlySalary * 0.5 // 演示
        
        // 简化：今日收入 - 这里随便给个估值
        todayEarnings = monthlySalary / 30.0 / 2.0
    }
    
    // MARK: - 被 SettingsView 调用的方法
    
    /// 用户更新了月薪
    func updateMonthlySalary(newSalary: Double) {
        monthlySalary = newSalary
        saveToStorage()
    }
    
    /// 用户更新了上下班时间
    func updateWorkTimes(startTime: Date, endTime: Date) {
        workStartTime = startTime
        workEndTime   = endTime
        saveToStorage()
    }
    
    /// 用户更新了自定义工作日
    func updateCustomWorkdays(workdays: [Bool]) {
        customWorkdays = workdays
        holidayManager.saveCustomWorkdays(workdays: workdays)
        saveToStorage()
    }
    
    /// 用户更新了入职日期
    func updateJoinDate(newDate: Date) {
        joinDate = newDate
        saveToStorage()
    }
    
    // MARK: - 数据持久化示例
    func loadFromStorage() {
        let ud = UserDefaults.standard
        
        // 月薪
        if let val = ud.value(forKey: "kMonthlySalary") as? Double {
            monthlySalary = val
        }
        
        // 上下班时间
        if let st = ud.value(forKey: "kWorkStartTime") as? TimeInterval {
            workStartTime = Date(timeIntervalSince1970: st)
        }
        if let et = ud.value(forKey: "kWorkEndTime") as? TimeInterval {
            workEndTime = Date(timeIntervalSince1970: et)
        }
        
        // 自定义工作日
        if let arr = ud.array(forKey: "kCustomWorkdays") as? [Bool], arr.count == 7 {
            customWorkdays = arr
        }
        
        // 入职日期
        if let joinInterval = ud.value(forKey: "kJoinDate") as? TimeInterval {
            joinDate = Date(timeIntervalSince1970: joinInterval)
        }
        
        // 是否隐藏金额
        hideAllAmounts = ud.bool(forKey: "kHideAllAmounts")
    }
    
    func saveToStorage() {
        let ud = UserDefaults.standard
        
        ud.set(monthlySalary, forKey: "kMonthlySalary")
        ud.set(workStartTime.timeIntervalSince1970, forKey: "kWorkStartTime")
        ud.set(workEndTime.timeIntervalSince1970, forKey: "kWorkEndTime")
        ud.set(customWorkdays, forKey: "kCustomWorkdays")
        ud.set(joinDate.timeIntervalSince1970, forKey: "kJoinDate")
        ud.set(hideAllAmounts, forKey: "kHideAllAmounts")
    }
    
    // MARK: - 辅助
    
    /// 生成“今天日期 + 指定 hour/minute”的 Date，用于初始化
    private func makeTodayDate(hour: Int, minute: Int) -> Date {
        let now = Date()
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: now)
        comps.hour = hour
        comps.minute = minute
        return Calendar.current.date(from: comps) ?? now
    }
    
    /// 将 “nextWorkday”的年月日 与 “workStartTime”的小时分钟 合并
    private func makeDateSameDayAs(_ day: Date, hourAndMinuteFrom time: Date) -> Date {
        let calendar = Calendar.current
        var dayComps = calendar.dateComponents([.year, .month, .day], from: day)
        let timeComps = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        dayComps.hour = timeComps.hour
        dayComps.minute = timeComps.minute
        dayComps.second = timeComps.second
        
        return calendar.date(from: dayComps) ?? day
    }
}
