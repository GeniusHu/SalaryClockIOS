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
    let workDuration = endTime.timeIntervalSince(startTime)
    let workedDuration = currentTime.timeIntervalSince(startTime)
    let ratio = max(0, min(workedDuration / workDuration, 1)) // 确保比例在 0 到 1 之间
    return dailySalary * ratio
}
