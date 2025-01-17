//
//  ShareButtonView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation
import SwiftUI

struct ShareButtonView: View {
    var body: some View {
        Button(action: {
            // 分享逻辑
            print("分享给好友")
        }) {
            HStack {
                Spacer() // 左侧留白
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.white)
                Text("分享给好友")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer() // 右侧留白
            }
            .padding(16) // 按钮内边距
            .background(Color(hex: "#FFD700")) // 按钮背景颜色
            .cornerRadius(12) // 圆角
        }
        .frame(maxWidth: .infinity) // 横向撑满
    }
}
