//
//  TipsCardView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation
import SwiftUI
struct TipsCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("摸鱼小贴士")
                .font(.headline)
                .foregroundColor(.black)
            Text("• 工作再累，也要记得喝水休息\n• 合理安排时间，提高工作效率\n• 适度摸鱼，保持心情愉悦")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}
struct ShareButtonView: View {
    var body: some View {
        Button(action: {
            // 分享功能
        }) {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("分享给好友")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#FFD700"))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
        }
    }
}
