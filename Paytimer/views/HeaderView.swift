//
//  HeaderView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//
import SwiftUI
import Foundation
struct HeaderView: View {
    @Binding var currentTime: Date

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("牛马时钟")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    // 设置按钮操作
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
            }
            .padding([.leading, .trailing], 16)

            HStack {
                Spacer()
                Text(currentTime.formattedTime(format: "yyyy/MM/dd HH:mm:ss"))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding(.vertical, 16)
        .background(Color(hex: "#FFD700"))
    }
}
