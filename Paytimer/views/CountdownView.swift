//
//  CountdownView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//
import SwiftUI
import Combine


struct CountdownCardView: View {
    @State private var days: String = "00"
    @State private var hours: String = "00"
    @State private var minutes: String = "00"
    @State private var seconds: String = "00"
    @State private var displayText: String = "距离下班时间还有"
    @State private var targetTime: Date = Date()

    private let holidayManager = HolidayManager.shared
    @StateObject private var timerManager = CountdownTimerManager()

    var body: some View {
        VStack(spacing: 16) {
            Text(displayText)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#374151"))
            
            HStack(spacing: 12) {
                TimeBlockView(value: days, unit: "天")
                TimeBlockView(value: hours, unit: "时")
                TimeBlockView(value: minutes, unit: "分")
                TimeBlockView(value: seconds, unit: "秒")
            }
            .frame(maxWidth: .infinity)
            
            Text("目标时间: \(formatDate(targetTime))")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#6B7280"))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
        .frame(maxWidth: .infinity)
        .onAppear {
                }
                .onReceive(timerManager.$currentTime) { _ in
                    updateCountdown()
                    updateTargetTime()
                }
    }
   
    private func updateCountdown() {
        let interval = Int(targetTime.timeIntervalSince(timerManager.currentTime))
        if interval > 0 {
            days = String(format: "%02d", interval / 86400)
            hours = String(format: "%02d", (interval % 86400) / 3600)
            minutes = String(format: "%02d", (interval % 3600) / 60)
            seconds = String(format: "%02d", interval % 60)
        } else {
            days = "00"
            hours = "00"
            minutes = "00"
            seconds = "00"
            updateTargetTime()
        }
    }
    
    
    public func updateTargetTime() {
           print("正在更新目标时间...")
           let now = timerManager.currentTime
           let calendar = Calendar.current
           let startOfToday = calendar.startOfDay(for: now)

           guard let workStartTime = holidayManager.getWorkStartTime().toDate(format: "HH:mm"),
                 let workEndTime = holidayManager.getWorkEndTime().toDate(format: "HH:mm") else {
               print("无法获取上下班时间")
               targetTime = now
               displayText = "时间数据缺失"
               return
           }

           let workStartDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: workStartTime),
                                                 minute: calendar.component(.minute, from: workStartTime),
                                                 second: 0, of: startOfToday)!
           let workEndDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: workEndTime),
                                               minute: calendar.component(.minute, from: workEndTime),
                                               second: 0, of: startOfToday)!

           if holidayManager.isWorkday(date: now) {
               if now < workStartDateTime {
                   targetTime = workStartDateTime
                   displayText = "距离上班时间还有"
               } else if now < workEndDateTime {
                   targetTime = workEndDateTime
                   displayText = "距离下班时间还有"
               } else {
                   if let nextWorkday = holidayManager.nextWorkday(from: now) {
                       targetTime = calendar.date(bySettingHour: calendar.component(.hour, from: workStartTime),
                                                  minute: calendar.component(.minute, from: workStartTime),
                                                  second: 0, of: nextWorkday)!
                       displayText = "距离下次上班还有"
                   }
               }
           } else {
               if let nextWorkday = holidayManager.nextWorkday(from: now) {
                   targetTime = calendar.date(bySettingHour: calendar.component(.hour, from: workStartTime),
                                              minute: calendar.component(.minute, from: workStartTime),
                                              second: 0, of: nextWorkday)!
                   displayText = "距离下次上班还有"
               }
           }
           print("更新后的目标时间: \(targetTime), 显示文本: \(displayText)")
       }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: date)
    }
}

struct TimeBlockView: View {
    var value: String
    var unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 24, weight: .bold)) // 数字样式
                .foregroundColor(Color(hex: "#1F2937")) // 深黑色
            Text(unit)
                .font(.system(size: 14)) // 单位样式
                .foregroundColor(Color(hex: "#4B5563")) // 中灰色
        }
        .frame(width: 70, height: 70)
        .background(Color(hex: "#FFD700")) // 金黄色背景
        .cornerRadius(12)
    }
}
