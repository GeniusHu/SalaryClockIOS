//
//  CountdownView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import SwiftUI

struct CountdownCardView: View {
    var workEndTime: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("距离下次上班还有")
                .font(.system(size: 18, weight: .bold)) // 调整字体大小与样式
                .foregroundColor(Color(hex: "#374151")) // 深灰色
            
            HStack(spacing: 12) { // 调整时间块的间距
                TimeBlockView(value: "00", unit: "天")
                TimeBlockView(value: "05", unit: "时")
                TimeBlockView(value: "36", unit: "分")
                TimeBlockView(value: "07", unit: "秒")
            }
            .frame(maxWidth: .infinity) // 确保时间块的 HStack 填充父视图宽度
            
            Text("下次上班时间: \(workEndTime)")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#6B7280")) // 灰色
        }
        .padding(.vertical, 16) // 垂直内边距
        .padding(.horizontal, 24) // 水平内边距
        .background(Color.white) // 卡片背景为白色
        .cornerRadius(12) // 圆角效果
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2) // 更加柔和的阴影效果
        .frame(maxWidth: .infinity) // 确保整个卡片填充父视图宽度
    }
}

struct TimeBlockView: View {
    var value: String
    var unit: String

    var body: some View {
        VStack(spacing: 4) { // 调整数字和单位之间的间距
            Text(value)
                .font(.system(size: 24, weight: .bold)) // 更大更粗的数字字体
                .foregroundColor(Color(hex: "#1F2937")) // 深黑色
            Text(unit)
                .font(.system(size: 14)) // 稍大的单位字体
                .foregroundColor(Color(hex: "#4B5563")) // 中灰色
        }
        .frame(width: 70, height: 70) // 时间块大小一致
        .background(Color(hex: "#FFD700")) // 更亮的金黄色背景
        .cornerRadius(12) // 圆角
    }
}
