//
//  EarningsCardView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import SwiftUI

struct EarningsCardView: View {
    @ObservedObject private var appData = AppDataManager.shared

    var body: some View {
        VStack(spacing: 12) {
            EarningsRow(title: "今日打工已赚", amount: appData.todayEarnings, itemKey: "today")
            EarningsRow(title: "本月打工已赚", amount: appData.monthlyEarnings, itemKey: "month")
            EarningsRow(title: "今年打工已赚", amount: appData.yearlyEarnings, itemKey: "year")
        }
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct EarningsRow: View {
    var title: String
    var amount: Double
    let itemKey: String

    var body: some View {
        // 1. 先判断是否要隐藏
               //   - 如果 hideAllAmounts=true，则无条件显示 "***"
               //   - 否则再看 itemVisibility[itemKey] 是否为 true
               let isHidden = AppDataManager.shared.hideAllAmounts || (AppDataManager.shared.itemVisibility[itemKey] ?? false)
        // 2. 显示文案
               let displayAmount: String = {
                   if isHidden {
                       return "***"
                   } else {
                       return String(format: "%.2f", amount)
                   }
               }()
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14))
                .bold()
                .foregroundColor(Color(hex: "#4B5563")) // 中灰

            HStack(spacing: 8) {
                Text("¥\(displayAmount)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#CA8A04")) // 金额颜色
                Button(action: {
                    // 切换单项的隐藏状态
                    AppDataManager.shared.toggleItemVisibility(for: itemKey)
                    if isHidden {
                        "***"
                    } else {
                        Text(String(format: "%.2f", amount))
                    }
                }) {
                    // 如果当前隐藏，则图标用 eye.slash.fill
                                       // 如果当前显示，则图标用 eye.fill
                                       Image(systemName: isHidden ? "eye.slash.fill" : "eye.fill")
                                           .foregroundColor(Color(hex: "#6B7280"))
                }
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
    }
}
