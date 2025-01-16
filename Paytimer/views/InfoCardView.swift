//
//  InfoCardView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//
import SwiftUI
import Foundation
struct InfoCardView: View {
    var userSettings: UserSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("入职时间: \(userSettings.joinDate)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
            HStack {
                Text("月薪:")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text("¥\(userSettings.monthlySalary, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#FFD700"))
                Spacer()
                Button(action: {
                    // 隐藏金额按钮操作
                }) {
                    Image(systemName: "eye.slash")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity) // 确保充满宽度
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
