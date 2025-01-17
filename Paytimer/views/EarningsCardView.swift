//
//  EarningsCardView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation
import SwiftUI

struct EarningsCardView: View {
    @ObservedObject var earningsManager: EarningsManager

    var body: some View {
        VStack(spacing: 12) {
            EarningsRow(title: "今日打工已赚", amount: earningsManager.earnings.today)
            EarningsRow(title: "本月打工已赚", amount: earningsManager.earnings.month)
            EarningsRow(title: "今年打工已赚", amount: earningsManager.earnings.year)
        }
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2) // 阴影效果
    }
}

struct EarningsRow: View {
    var title: String
    var amount: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14))
                .bold()
                .foregroundColor(Color(hex: "#4b5563")) // 灰色字体

            HStack(spacing: 8) {
                Text("¥\(amount, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#CA8A04")) // 金额颜色
                Button(action: {
                    // 隐藏金额操作
                }) {
                    Image(systemName: "eye.slash")
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
