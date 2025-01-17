//
//  IncomeCalculator.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation
import Foundation

class IncomeCalculator {
    private let holidayManager = HolidayManager.shared
    private let calendar: Calendar

       init() {
           var calendar = Calendar.current
           calendar.locale = Locale(identifier: "en_US") // 强制使用英文的星期名称
           self.calendar = calendar
       }
    
    
    // 计算每月的工作日
    func calculateWorkdays(for month: Int, year: Int, customWorkdays: [String: Bool]) -> Int {
        guard let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return 0
        }

        let customWorkdaySymbols = customWorkdays.keys // 用户自定义的工作日 (存储为英文)
        var workdays = 0

        for day in range {
                guard let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) else { continue }

                // 获取英文的星期名称
                let weekdaySymbol = calendar.weekdaySymbols[calendar.component(.weekday, from: date) - 1]
                let dateString = formatDate(date, format: "yyyy-MM-dd")

                // 检查以下条件：
                // 1. 是否为用户定义的工作日
                // 2. 是否为节假日 (法定节假日则跳过)
            
            if let isWorkday = customWorkdays[weekdaySymbol], isWorkday, !holidayManager.isHoliday(date: dateString) {
                    workdays += 1
                }
            }

        return workdays
    }

    // 计算每日工资
    func calculateDailySalary(monthlySalary: Double, workdays: Int) -> Double {
        return workdays > 0 ? monthlySalary / Double(workdays) : 0.0
    }

    // 计算今日已工作时间
    func calculateWorkedTime(today: Date, startTime: String, endTime: String) -> TimeInterval {
        guard let start = startTime.toDate(format: "HH:mm"),
              let end = endTime.toDate(format: "HH:mm") else {
            return 0
        }

        let startDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: start),
                                          minute: calendar.component(.minute, from: start),
                                          second: 0, of: today)!
        let endDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: end),
                                        minute: calendar.component(.minute, from: end),
                                        second: 0, of: today)!

        let now = Date()
        if now < startDateTime {
            return 0
        } else if now > endDateTime {
            return endDateTime.timeIntervalSince(startDateTime)
        } else {
            return now.timeIntervalSince(startDateTime)
        }
    }

    // 计算今日收入
    func calculateTodayEarnings(dailySalary: Double, workedTime: TimeInterval, totalWorkTime: TimeInterval) -> Double {
        return totalWorkTime > 0 ? dailySalary * (workedTime / totalWorkTime) : 0.0
    }

    // 计算本月收入
    func calculateMonthlyEarnings(dailySalary: Double, workdaysCompleted: Int) -> Double {
        return dailySalary * Double(workdaysCompleted)
    }

    // 计算全年收入
    func calculateYearlyEarnings(dailySalary: Double, totalWorkdays: Int) -> Double {
        return dailySalary * Double(totalWorkdays)
    }

    // 日期格式化辅助方法
    private func formatDate(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
