//
//  ShareButtonView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//
import Foundation
import SwiftUI

struct ShareButtonView: View {
    @ObservedObject private var appData = AppDataManager.shared

    var body: some View {
        Button(action: {
            shareApp()
        }) {
            HStack {
                Spacer() // 左侧留白
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.white)
                Text("分享给好友")
                    .font(.headline)
                    .foregroundColor(Color(hex:"#FFD700"))
                Spacer() // 右侧留白
            }
            .padding(16) // 按钮内边距
            .background(Color.white) // 按钮背景颜色
            .cornerRadius(12) // 圆角
        }
        .frame(maxWidth: .infinity) // 横向撑满
    }

    /// 分享功能
    private func shareApp() {
        // 生成分享内容
        let shareContent = generateShareContent()

        // 分享操作
        let activityVC = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true, completion: nil)
        }
    }

    /// 生成分享内容
    private func generateShareContent() -> String {
        // 检查是否隐藏金额
        let isHidden = appData.hideAllAmounts

        // 获取各项数据
        let monthlySalary = isHidden || (appData.itemVisibility["salary"] ?? false) ? "***" : String(format: "¥%.2f", appData.monthlySalary)
        let todayEarnings = isHidden || (appData.itemVisibility["today"] ?? false) ? "***" : String(format: "¥%.2f", appData.todayEarnings)
        let monthlyEarnings = isHidden || (appData.itemVisibility["month"] ?? false) ? "***" : String(format: "¥%.2f", appData.monthlyEarnings)
        let yearlyEarnings = isHidden || (appData.itemVisibility["year"] ?? false) ? "***" : String(format: "¥%.2f", appData.yearlyEarnings)

        // 构造分享内容
        let content = """
        🤑 我的工作收入统计：
        - 月薪：\(monthlySalary)
        - 今日收入：\(todayEarnings)
        - 本月收入：\(monthlyEarnings)
        - 今年收入：\(yearlyEarnings)

        下载 Paytimer App，一起管理你的工作时间和收入吧！👇
        下载链接：https://example.com
        """
        return content
    }
}
