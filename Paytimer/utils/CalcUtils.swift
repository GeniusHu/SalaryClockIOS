//
//  CalcUtils.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation

func calculateDailyEarnings(salary: Double, workDays: Int) -> Double {
    return salary / Double(workDays)
}

func calculateCurrentEarnings(dailySalary: Double, startTime: Date, endTime: Date, currentTime: Date) -> Double {
    let totalWorkTime = endTime.timeIntervalSince(startTime) // 总工作时间（秒）
    let workedTime: TimeInterval

    // 确保 currentTime 在 startTime 和 endTime 范围内
    if currentTime < startTime {
        workedTime = 0 // 尚未到上班时间
    } else if currentTime > endTime {
        workedTime = totalWorkTime // 已超过下班时间
    } else {
        workedTime = currentTime.timeIntervalSince(startTime) // 已工作时间
    }

    print("总工作时间: \(totalWorkTime), 已工作时间: \(workedTime)")

    // 计算收入
    let earnings = dailySalary * (workedTime / totalWorkTime)
    print("计算的今日收入: \(earnings)")
    return earnings
}


// 计算本月收入
func calculateMonthlyEarnings(salary: Double, workDays: Int) -> Double {
    return salary
}

// 计算全年收入
func calculateYearlyEarnings(salary: Double) -> Double {
    return salary * 12
}
