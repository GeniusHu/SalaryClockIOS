//
//  EarningsManager.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation

class EarningsManager: ObservableObject {
    static let shared = EarningsManager() // 默认初始化时传入一个默认值
    private let userDefaults = UserDefaults.standard

    @Published var earnings: Earnings

     let incomeCalculator = IncomeCalculator()
     let holidayManager = HolidayManager.shared
     let calendar = Calendar.current
     var monthlySalary: Double
     var dailySalary: Double
     var workdaysThisMonth: Int

    private init() {
        // 从 UserDefaults 加载月薪
      self.monthlySalary = userDefaults.double(forKey: "MonthlySalary")
               if self.monthlySalary == 0 {
                   self.monthlySalary = 10000 // 默认值
               }

        self.earnings = Earnings(today: 0, month: 0, year: 0)

        // 初始化数据
        let currentDate = Date()
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)

        // 获取用户定义的工作日配置
        let customWorkdays = holidayManager.loadCustomWorkdays()

        // 计算本月工作日数
        self.workdaysThisMonth = incomeCalculator.calculateWorkdays(for: month, year: year, customWorkdays: customWorkdays)
        self.dailySalary = incomeCalculator.calculateDailySalary(monthlySalary: monthlySalary, workdays: workdaysThisMonth)

        // 打印调试信息
        print("本月工作日数: \(workdaysThisMonth)")
        print("每日薪水： \(dailySalary)")

        // 初始化本月和全年收入
        self.updateMonthlyAndYearlyEarnings()
    }
    
    /// 更新月薪
       func updateMonthlySalary(newSalary: Double) {
           self.monthlySalary = newSalary
           userDefaults.set(newSalary, forKey: "MonthlySalary")

           // 重新计算每日薪水
           self.dailySalary = incomeCalculator.calculateDailySalary(monthlySalary: newSalary, workdays: workdaysThisMonth)

           // 更新本月和全年收入
           updateMonthlyAndYearlyEarnings()
       }

    /// 更新今日收入
    func updateTodayEarnings() {
        let currentDate = Date()
        let isWorkdayToday = holidayManager.isWorkday(date: currentDate)

        // 如果今天是工作日，计算工作时长和收入
        let workedTimeToday = isWorkdayToday ? incomeCalculator.calculateWorkedTime(
            today: currentDate,
            startTime: holidayManager.getWorkStartTime(),
            endTime: holidayManager.getWorkEndTime()
        ) : 0

        let todayEarnings = isWorkdayToday ? incomeCalculator.calculateTodayEarnings(
            dailySalary: dailySalary,
            workedTime: workedTimeToday,
            totalWorkTime: 8 * 3600 // 8小时工作日
        ) : 0

        // 更新今日收入
        DispatchQueue.main.async {
            self.earnings.today = todayEarnings
        }
    }

    /// 初始化或在月份切换时更新本月和全年收入
    func updateMonthlyAndYearlyEarnings() {
        let currentDate = Date()
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!

        // 计算本月已完成的工作日
        var completedWorkdaysThisMonth = 0
        if let rangeOfDays = calendar.range(of: .day, in: .month, for: startOfMonth) {
            for day in rangeOfDays {
                guard let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth),
                      holidayManager.isWorkday(date: date), // 判断是否为工作日
                      date < currentDate else { continue }
                completedWorkdaysThisMonth += 1
            }
        }

        // 本月收入
        let monthlyEarnings = incomeCalculator.calculateMonthlyEarnings(
            dailySalary: dailySalary,
            workdaysCompleted: completedWorkdaysThisMonth
        )

        // 全年收入
        let year = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let previousMonthsEarnings = Double(currentMonth - 1) * monthlySalary
        let yearlyEarnings = previousMonthsEarnings + monthlyEarnings

        // 更新本月和全年收入
        DispatchQueue.main.async {
            self.earnings.month = monthlyEarnings
            self.earnings.year = yearlyEarnings
        }
    }
}
