//
//  HeaderView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//
import SwiftUI

struct HeaderView: View {
    @ObservedObject var appData = AppDataManager.shared
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 10) {
            // 第一行：标题 + 设置按钮
            HStack {
                Text("牛马时钟")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
            }
            .fullScreenCover(isPresented: $showSettings) {
                SettingsView(isPresented: $showSettings)
            }
            .padding([.leading, .trailing], 16)

            // 第二行：当前时间
            HStack {
                Spacer()
                Text(appData.currentTime.formattedTime("yyyy/MM/dd HH:mm:ss"))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding(.vertical, 16)
        .background(Color(hex: "#FFD700"))
    }
}
