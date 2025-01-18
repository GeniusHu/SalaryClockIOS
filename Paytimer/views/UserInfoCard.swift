//
//  UserInfoCard.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation
import SwiftUI

// 原本的 userSettings 依赖都去掉
struct UserInfoCard: View {
    @ObservedObject var appData = AppDataManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("当前时间: \(appData.currentTime.formattedTime("yyyy-MM-dd HH:mm:ss"))")
            Text("入职日期: \(appData.joinDate.formattedTime("yyyy-MM-dd"))")
            Text("月薪: \(appData.monthlySalary, specifier: "%.2f")")
        }
        .padding()
        .background(Color.primary.opacity(0.1))
        .cornerRadius(10)
    }
}
