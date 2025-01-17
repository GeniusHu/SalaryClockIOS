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
    @State private var showSettings = false // 控制设置页的显示状态


    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("牛马时钟")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    showSettings = true // 打开设置页
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
            }.fullScreenCover(isPresented: $showSettings) {
                SettingsView(isPresented: $showSettings, earningsManager: EarningsManager.shared)
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
