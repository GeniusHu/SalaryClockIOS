//
//  CountdownView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//
import SwiftUI
import Combine

struct CountdownCardView: View {
    @ObservedObject private var appData = AppDataManager.shared

    var body: some View {
        VStack(spacing: 16) {
            // 显示当前的提示语
            Text(appData.displayText)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(hex: "#374151"))
            
            // 显示天/时/分/秒
            HStack(spacing: 12) {
                TimeBlockView(value: appData.days, unit: "天")
                TimeBlockView(value: appData.hours, unit: "时")
                TimeBlockView(value: appData.minutes, unit: "分")
                TimeBlockView(value: appData.seconds, unit: "秒")
            }
            .frame(maxWidth: .infinity)
            
            // 显示目标时间
            Text("目标时间: \(appData.targetTime.formattedTime("yyyy/MM/dd HH:mm:ss"))")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#6B7280"))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 2)
        .frame(maxWidth: .infinity)
    }
}
