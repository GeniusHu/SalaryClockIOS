//
//  StringsUtils.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation


// String 转 Date 工具
extension String {
    func toDate(format: String = "HH:mm") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // 获取当前日期
        let today = Date()
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: today)
        
        // 将当前日期的年月日和字符串时间结合
        guard let timeOnlyDate = dateFormatter.date(from: self) else { return nil }
        let timeComponents = calendar.dateComponents([.hour, .minute], from: timeOnlyDate)
        
        var finalComponents = DateComponents()
        finalComponents.year = currentDateComponents.year
        finalComponents.month = currentDateComponents.month
        finalComponents.day = currentDateComponents.day
        finalComponents.hour = timeComponents.hour
        finalComponents.minute = timeComponents.minute
        
        return calendar.date(from: finalComponents)
    }
}


import Foundation

extension Date {
    func formattedTime(format: String = "HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
}

import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = hex.hasPrefix("#") ? 1 : 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
