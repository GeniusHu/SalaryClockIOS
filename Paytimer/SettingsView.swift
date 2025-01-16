//
//  SettingsView.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("settings.salary", comment: ""))) {
                    Text("月薪设置")
                }
                Section(header: Text(NSLocalizedString("settings.work_hours", comment: ""))) {
                    Text("工作时间设置")
                }
                Section(header: Text(NSLocalizedString("settings.join_date", comment: ""))) {
                    Text("入职日期设置")
                }
                Section(header: Text(NSLocalizedString("settings.work_days", comment: ""))) {
                    Text("工作日选择")
                }
                Section(header: Text(NSLocalizedString("settings.hide_money", comment: ""))) {
                    Toggle("隐藏金额", isOn: .constant(false))
                }
            }
            .navigationTitle(NSLocalizedString("settings.title", comment: ""))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
