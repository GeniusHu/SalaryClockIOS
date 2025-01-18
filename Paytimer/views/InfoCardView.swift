//
//  InfoCardView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//
import SwiftUI
import Foundation

struct InfoCardView: View {
    @ObservedObject var appData = AppDataManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 入职时间
            Text("入职时间: \(appData.joinDate.formattedTime("yyyy/MM/dd"))")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            // 月薪
            HStack {
                Text("月薪:")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text("¥\(appData.monthlySalary, specifier: "%.2f")")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(hex: "#FFD700"))
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
