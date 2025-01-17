//
//  HolidayManager.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation

struct Holiday: Codable {
    let date: String
    let isHoliday: Bool
    let name: String
}

class HolidayManager {
    static let shared = HolidayManager()
    private var holidays: [String: Holiday] = [:] // 使用日期作为键存储
    private let calendar = Calendar.current

    private init() {}

    // MARK: - 节假日相关逻辑

    /// 从网络获取节假日
    func fetchHolidays(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://www.shuyz.com/githubfiles/china-holiday-calender/master/holidayAPI.json") else {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching holidays: \(error)")
                completion(false)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }

            do {
                let holidaysList = try JSONDecoder().decode([Holiday].self, from: data)
                var tempHolidays: [String: Holiday] = [:]
                for holiday in holidaysList {
                    tempHolidays[holiday.date] = holiday
                }
                DispatchQueue.main.async {
                    self.holidays = tempHolidays
                    completion(true)
                }
            } catch {
                print("Error decoding holidays JSON: \(error)")
                completion(false)
            }
        }.resume()
    }

    /// 判断是否是法定节假日
    func isHoliday(date: String) -> Bool {
        return holidays[date]?.isHoliday ?? false
    }

    // MARK: - 用户自定义设置

    /// 获取用户自定义的工作日
    func loadCustomWorkdays() -> [String: Bool] {
        return UserDefaults.standard.dictionary(forKey: "CustomWorkdays") as? [String: Bool] ?? [
            "Monday": true,
            "Tuesday": true,
            "Wednesday": true,
            "Thursday": true,
            "Friday": true,
            "Saturday": false,
            "Sunday": false
        ]
    }

    /// 获取用户自定义的上班时间，默认早九
    func getWorkStartTime() -> String {
        return UserDefaults.standard.string(forKey: "WorkStartTime") ?? "09:00"
    }

    /// 获取用户自定义的下班时间，默认晚六
    func getWorkEndTime() -> String {
        return UserDefaults.standard.string(forKey: "WorkEndTime") ?? "18:00"
    }

    /// 保存用户自定义的上下班时间
    func saveWorkTimes(startTime: String, endTime: String) {
        UserDefaults.standard.set(startTime, forKey: "WorkStartTime")
        UserDefaults.standard.set(endTime, forKey: "WorkEndTime")
    }

    // MARK: - 工作日逻辑

    /// 判断是否是工作日
    func isWorkday(date: Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

        // 判断是否为法定节假日
        if isHoliday(date: dateString) {
            return false
        }

        // 使用固定的英文 weekdaySymbols 符号
        let weekdaySymbols = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let weekday = calendar.component(.weekday, from: date) // 1 是周日，7 是周六
        let customWorkdays = loadCustomWorkdays()
        let dayName = weekdaySymbols[weekday - 1]

        return customWorkdays[dayName] ?? false
    }

    /// 查找下一个工作日
    func nextWorkday(from date: Date) -> Date? {
        var nextDate = date
        while true {
            nextDate = calendar.date(byAdding: .day, value: 1, to: nextDate)!
            if isWorkday(date: nextDate) {
                return nextDate
            }
        }
    }

    // MARK: - 时间计算逻辑

    /// 距离下班还有多久
    func timeUntilEndOfWork(for date: Date) -> TimeInterval? {
        guard isWorkday(date: date) else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        // 获取用户自定义的上下班时间
        guard let startTime = dateFormatter.date(from: getWorkStartTime()),
              let endTime = dateFormatter.date(from: getWorkEndTime()) else { return nil }

        let startOfToday = calendar.startOfDay(for: date)
        let workEndTime = calendar.date(byAdding: .hour, value: calendar.component(.hour, from: endTime), to: startOfToday)!

        return workEndTime.timeIntervalSince(date)
    }

    /// 距离下一个工作日的上班时间有多久
    func timeUntilNextWorkStart(from date: Date) -> TimeInterval? {
        guard let nextWorkday = nextWorkday(from: date) else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        // 获取用户自定义的上班时间
        guard let startTime = dateFormatter.date(from: getWorkStartTime()) else { return nil }

        let startOfNextDay = calendar.startOfDay(for: nextWorkday)
        let nextWorkStartTime = calendar.date(byAdding: .hour, value: calendar.component(.hour, from: startTime), to: startOfNextDay)!

        return nextWorkStartTime.timeIntervalSince(date)
    }
}
