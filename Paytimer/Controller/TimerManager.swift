//
//  TimerManager.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//
import Foundation
import Combine

class TimerManager: ObservableObject {
    @Published var currentTime: Date = Date()
    @Published var earnings: Earnings = Earnings(today: 0, month: 0, year: 0)

    private var timer: AnyCancellable?
    private var userSettings: UserSettings

    init(userSettings: UserSettings) {
        self.userSettings = userSettings
        calculateEarnings() // 初始化时计算一次
    }

    func startTimer() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] time in
                guard let self = self else { return }
                self.currentTime = time
                self.calculateEarnings() // 每秒更新收入
                print("workStartTime: \(userSettings.workStartTime)")
                print("workEndTime: \(userSettings.workEndTime)")
            }
    }

    func stopTimer() {
        timer?.cancel()
    }

    private func calculateEarnings() {
        // 提供格式 "HH:mm" 解析时间字符串
        guard let startTime = userSettings.workStartTime.toDate(format: "HH:mm"),
              let endTime = userSettings.workEndTime.toDate(format: "HH:mm") else {
            print("时间转换失败: \(userSettings.workStartTime), \(userSettings.workEndTime)")
            return
        }
       

        // 计算日薪
        let dailySalary = calculateDailyEarnings(
            salary: userSettings.monthlySalary,
            workDays: userSettings.workDays.count
        )

        // 计算今日收入
        earnings.today = calculateCurrentEarnings(
            dailySalary: dailySalary,
            startTime: startTime,
            endTime: endTime,
            currentTime: currentTime
        )
        
        print("每日工资: \(dailySalary)")
          print("开始时间: \(startTime)")
          print("结束时间: \(endTime)")
          print("当前时间: \(currentTime)")
          
        
        print("每日工资：\(dailySalary)")
        print("今日收入：\(earnings.today)")
    }
    
}
