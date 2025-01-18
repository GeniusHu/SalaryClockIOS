//
//  InfoCardView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//
import SwiftUI
import Foundation
import SwiftUI
import Foundation

struct InfoCardView: View {
    @ObservedObject var appData = AppDataManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 月薪
            HStack {
                Text("月薪:")
                    .font(.system(size: 14))
                    .foregroundColor(.black)

                // 显示金额或 "***"
                let isHidden = appData.hideAllAmounts || (appData.itemVisibility["salary"] ?? false)
                Text(isHidden ? "***" : "¥\(appData.monthlySalary, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#FFD700"))

                // 小眼睛按钮
                Button(action: {
                    appData.toggleItemVisibility(for: "salary")
                }) {
                    Image(systemName: isHidden ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(Color(hex: "#6B7280"))
                }
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
