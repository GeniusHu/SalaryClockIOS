import Foundation

/**
 `HolidayManager` 负责：
 1. 管理并判断法定节假日
 2. 管理用户自定义的工作日(周一~周日哪几天是休息/上班)
 3. 提供上下班时间的设定与读取
 4. 提供“下一工作日”等常用业务方法
 */
class HolidayManager {
    
    // MARK: - 单例
    static let shared = HolidayManager()
    
    // MARK: - 关键属性
    
    /// 法定节假日列表（以 [String: Holiday] 存储，Key是 "yyyy-MM-dd" 字符串）
    private(set) var holidays: [String: Holiday] = [:]
    
    /// 用户自定义的工作日设置（长度7），对应周一~周日，true表示工作日，false表示休息
    /// 默认 [true, true, true, true, true, false, false] 表示周一~周五上班，周六、周日休息
    private(set) var customWorkdays: [Bool] = [true, true, true, true, true, false, false]
    
    /// 用户设置的上班时间
    private var workStartTime: Date
    
    /// 用户设置的下班时间
    private var workEndTime: Date
    
    // MARK: - 私有属性
    private let userDefaults = UserDefaults.standard
    
    /// 存储 key：法定节假日
    private let holidayStoreKey = "storedHolidays"
    /// 存储 key：自定义工作日
    private let customWorkdaysKey = "customWorkdays"
    /// 存储 key：上班时间
    private let workStartTimeKey = "workStartTimeKey"
    /// 存储 key：下班时间
    private let workEndTimeKey = "workEndTimeKey"
    
    // MARK: - 初始化（单例模式：私有构造）
    private init() {
            //
            // 第一步：先给所有存储属性“初始值”
            //
            self.holidays = [:]  // 先给空字典
            self.customWorkdays = [true, true, true, true, true, false, false] // 默认周一~周五
            // 先随便给个 Date()，或做一个默认 9点、18点
            self.workStartTime = Date()
            self.workEndTime   = Date()
            
            //
            // 第二步：再通过“加载”方法覆盖它们
            //
        // 2) 加载“内置 2025~2026 节假日”到 holidays
                loadBuiltInHolidaysFromBundle()
            
            // 覆盖 customWorkdays
            let loadedWorkdays = loadCustomWorkdays()
            self.customWorkdays = loadedWorkdays
            
            // 覆盖上下班时间
            let (start, end) = loadWorkTime()
            self.workStartTime = start ?? makeDate(hour: 9, minute: 0)
            self.workEndTime   = end   ?? makeDate(hour: 18, minute: 0)
        }
    
    /**
         从本地 Bundle 中名为 `Holidays2025_2026.json` 的文件读取节假日
         并将其放入 `holidays` 字典中
         */
        private func loadBuiltInHolidaysFromBundle() {
            guard let url = Bundle.main.url(forResource: "Holidays2025_2026", withExtension: "json") else {
                print("未找到 Holidays2025_2026.json 文件")
                return
            }
            do {
                let data = try Data(contentsOf: url)
                let holidayArr = try JSONDecoder().decode([Holiday].self, from: data)
                
                // 将其转为字典写入
                for h in holidayArr {
                    let key = dateString(h.date)
                    holidays[key] = h
                }
            } catch {
                print("读取本地JSON失败:", error)
            }
        }
    
    // MARK: - 节假日逻辑
    
    /**
     判断某天是否为**法定节假日**。
     - parameter date: 要判断的日期
     - returns: 若是节假日则返回 `true`，否则 `false`
     */
    func isHoliday(date: Date) -> Bool {
//        let key = dateString(date)
//        return holidays[key] != nil
        
        // 获取星期几，1~7 (周日=1, 周一=2, ..., 周六=7)
           let weekday = Calendar.current.component(.weekday, from: date)
           
           // 如果是周六(7)或周日(1)，返回 true；否则返回 false
           return weekday == 1 || weekday == 7
    }
    
    /**
     新增或更新一个法定节假日
     - parameter holiday: Holiday结构体
     
     示例：`let holiday = Holiday(name: "元旦", date: someDate); HolidayManager.shared.addHoliday(holiday)`
     */
    func addHoliday(_ holiday: Holiday) {
        let key = dateString(holiday.date)
        holidays[key] = holiday
        
        // 同步保存到本地
        saveHolidays()
    }
    
    /**
     删除指定日期的法定节假日
     - parameter date: 需要删除的具体日期
     */
    func removeHoliday(on date: Date) {
        let key = dateString(date)
        holidays.removeValue(forKey: key)
        
        // 同步保存到本地
        saveHolidays()
    }
    
    // MARK: - 工作日逻辑
    
    /**
     判断某天是否为**工作日**。
     
     - parameter date: 要判断的日期
     - parameter customWorkdays: 用户自定义工作日数组，[0]对应周一,...,[6]对应周日
     - returns: 若是工作日则返回 `true`
     
     逻辑：
     1. 若是法定节假日，直接返回 false
     2. 否则根据 customWorkdays 判断当天是不是用户定义的工作日
     */
    func isWorkday(date: Date, customWorkdays: [Bool]) -> Bool {
//        // 如果是节假日，直接 return false
//        if isHoliday(date: date) {
//            return false
//        }
//        
//        // 根据 weekday 判断
//        let weekday = Calendar.current.component(.weekday, from: date) // 1~7 (周日=1, 周一=2, ...)
//        // 转换成自定义 workdays 的索引（0~6 的顺序：周一=0,...周日=6）
//        let customIndex = (weekday + 5) % 7
//        
//        return customWorkdays[customIndex]
        
        let calendar = Calendar.current
           let weekday = calendar.component(.weekday, from: date) // 1~7 (周日=1, 周一=2, ..., 周六=7)

           // 判断是否为工作日（周一到周五）
           return weekday >= 2 && weekday <= 6
    }
    
    /**
     找到从指定日期开始的下一**工作日**（包含当天）。
     - parameter from: 起始日期
     - returns: 返回第一个满足工作日条件的日期，如果在一年内找不到则返回 nil（极端情况）
     
     实现思路：
       从 `from` 这一天开始往后逐天 +1，检查是否为工作日，不是就继续下一天
     */
    func nextWorkday(from: Date) -> Date? {
//        var candidate = from
//        
//        // 最多循环 365 天，防止极端死循环
//        for _ in 0..<365 {
//            if isWorkday(date: candidate, customWorkdays: customWorkdays) {
//                return candidate
//            }
//            guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: candidate) else {
//                return nil
//            }
//            candidate = nextDay
//        }
//        return nil
        
        
        var candidate = from
            let calendar = Calendar.current

            // 最多循环 365 天，防止极端死循环
            for _ in 0..<365 {
                // 判断 candidate 是否是工作日（周一到周五）
                let weekday = calendar.component(.weekday, from: candidate) // 周日=1, 周一=2, ..., 周六=7
                if weekday >= 2 && weekday <= 6 {
                    // 如果是工作日（周一到周五），返回该日期
                    return candidate
                }
                // 增加一天
                guard let nextDay = calendar.date(byAdding: .day, value: 1, to: candidate) else {
                    return nil
                }
                candidate = nextDay
            }
            return nil
    }
    
    // MARK: - 上下班时间逻辑
    
    /**
     获取用户设置的“上班时间”（当日的Hour/Minute）。
     - returns: 上班时间的 Date（示例中只关心小时、分钟，其它部分是当日）
     */
    func getWorkStartTime() -> Date {
        return workStartTime
    }
    
    /**
     获取用户设置的“下班时间”（当日的Hour/Minute）。
     - returns: 下班时间的 Date
     */
    func getWorkEndTime() -> Date {
        return workEndTime
    }
    
    /**
     设置并保存上班时间
     - parameter hour: 小时
     - parameter minute: 分钟
     
     调用后，会同步保存到 UserDefaults
     */
    func setWorkStartTime(hour: Int, minute: Int) {
        self.workStartTime = makeDate(hour: hour, minute: minute)
        saveWorkTime()
    }
    
    /**
     设置并保存下班时间
     - parameter hour: 小时
     - parameter minute: 分钟
     
     调用后，会同步保存到 UserDefaults
     */
    func setWorkEndTime(hour: Int, minute: Int) {
        self.workEndTime = makeDate(hour: hour, minute: minute)
        saveWorkTime()
    }
    
    /**
     计算当前时间 `date` 距离下班的剩余秒数。
     - parameter date: 当前时间
     - returns: 若在工作时间段内，则返回剩余秒数；若已经过下班时间，返回 0 或 nil（看业务需要）
     */
    func timeUntilEndOfWork(for date: Date) -> TimeInterval {
        if date >= workEndTime {
            return 0
        }
        return workEndTime.timeIntervalSince(date)
    }
    
    // MARK: - 用户设置管理
    
    /**
     加载用户的自定义工作日设置。
     - returns: 解析后的自定义工作日数组，如果没存则返回默认值
     */
    func loadCustomWorkdays() -> [Bool] {
        guard let savedArray = userDefaults.array(forKey: customWorkdaysKey) as? [Bool],
              savedArray.count == 7
        else {
            return [true, true, true, true, true, false, false]
        }
        return savedArray
    }
    
    /**
     保存用户的自定义工作日设置到本地
     - parameter workdays: 新的自定义工作日数组
     */
    func saveCustomWorkdays(workdays: [Bool]) {
        userDefaults.set(workdays, forKey: customWorkdaysKey)
        customWorkdays = workdays
    }
    
    // MARK: - Private: 存储/加载上下班时间
    
    /**
     从 UserDefaults 加载上下班时间，如果没有存就返回 nil
     - returns: (workStartTime, workEndTime)
     */
    private func loadWorkTime() -> (Date?, Date?) {
        var start: Date? = nil
        var end: Date? = nil
        
        // 上班时间
        if let startInterval = userDefaults.object(forKey: workStartTimeKey) as? TimeInterval {
            start = Date(timeIntervalSince1970: startInterval)
        }
        // 下班时间
        if let endInterval = userDefaults.object(forKey: workEndTimeKey) as? TimeInterval {
            end = Date(timeIntervalSince1970: endInterval)
        }
        
        return (start, end)
    }
    
    /**
     将当前的 workStartTime / workEndTime 保存到 UserDefaults
     */
    private func saveWorkTime() {
        userDefaults.set(workStartTime.timeIntervalSince1970, forKey: workStartTimeKey)
        userDefaults.set(workEndTime.timeIntervalSince1970,   forKey: workEndTimeKey)
    }
    
    // MARK: - Private: 存储/加载法定节假日
    
    /**
     从持久化存储中加载 holidays
     这里示例采用 UserDefaults + JSON 编解码的形式
     也可改为网络请求或本地文件解析
     */
    private func loadHolidays() {
           guard let data = userDefaults.data(forKey: holidayStoreKey) else {
               holidays = [:]
               return
           }
           do {
               let arr = try JSONDecoder().decode([Holiday].self, from: data)
               var dict = [String: Holiday]()
               for h in arr {
                   dict[dateString(h.date)] = h
               }
               holidays = dict
           } catch {
               print("loadHolidays decode error:", error)
               holidays = [:]
           }
       }
       
    
    /**
     将 holidays 写回本地存储（UserDefaults）
     */
    private func saveHolidays() {
        let holidayArray = Array(holidays.values)  // 转回 [Holiday]
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(holidayArray)
            userDefaults.set(data, forKey: holidayStoreKey)
        } catch {
            print("saveHolidays() encode error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private Helpers
    
    /**
     将给定的“当日”与指定的小时/分钟组合成一个新的 Date
     - parameter hour: 小时（0-23）
     - parameter minute: 分（0-59）
     - returns: 组装好的当日 Date
     
     示例逻辑：在“今天”基础上，替换 hour/minute
     */
    private func makeDate(hour: Int, minute: Int) -> Date {
        let now = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day], from: now)
        components.hour = hour
        components.minute = minute
        components.second = 0
        return Calendar.current.date(from: components) ?? now
    }
    
    /**
     将 Date 转为 "yyyy-MM-dd" 字符串
     */
    private func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
