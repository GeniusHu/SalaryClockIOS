//
//  Extensions.swift
//  Paytimer
//
//  Created by Hu on 2025/1/19.
//

import Foundation
import SwiftUI

// MARK: - Color(hex:)
extension Color {
    /**
     让我们可以调用 Color(hex: "#FFD700") 这样的初始化方式。
     */
    init(hex: String) {
        // 去掉前后空格、转换大写
        var trimmed = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        // 如果开头是 "#", 去掉
        if trimmed.hasPrefix("#") {
            trimmed.removeFirst()
        }
        
        // 解析RGB
        var rgbValue: UInt64 = 0
        Scanner(string: trimmed).scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}

// MARK: - Date.formattedTime(...)
extension Date {
    /**
     让我们可以写 date.formattedTime("yyyy/MM/dd HH:mm:ss") 等自定义格式输出。
     */
    func formattedTime(_ format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}

/// 用于对部分角进行圆角
struct RoundedCorner: Shape {
    var radius: CGFloat = .zero
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

/// 扩展 View，让我们可以写 .cornerRadius(16, corners: [.topLeft, .topRight]) 等
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
