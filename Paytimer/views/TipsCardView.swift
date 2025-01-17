//
//  TipsCardView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import SwiftUI
import Foundation

struct TipsCardView: View {
    var tips: [String] = [
        "工作再累，也要记得喝水休息",
        "合理安排时间，提高工作效率",
        "适度摸鱼，保持心情愉悦"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("摸鱼小贴士")
                .font(.headline)
                .bold()
                .foregroundColor(.black)
            
            ForEach(tips, id: \.self) { tip in
                Text("• \(tip)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(16) // 内边距
        .frame(maxWidth: .infinity) // 横向撑满
        .background(Color.white) // 背景色
        .cornerRadius(12) // 圆角
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2) // 阴影
    }
}
