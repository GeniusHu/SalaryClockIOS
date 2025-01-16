import SwiftUI

struct SettingsView: View {
    @State private var settings = UserDefaultsManager.shared.getUserSettings()
    @AppStorage("themeMode") private var isDarkMode = false
    @State private var showingSalaryInput = false
    @State private var showingWorkDaysSelection = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本设置")) {
                    HStack {
                        Text("月薪")
                        Spacer()
                        Text(settings.hideAllMoney ? "****" : String(format: "¥%.2f", settings.monthlySalary))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingSalaryInput = true
                    }
                    
                    Toggle("隐藏金额", isOn: Binding(
                        get: { settings.hideAllMoney },
                        set: { newValue in
                            settings.hideAllMoney = newValue
                            UserDefaultsManager.shared.saveUserSettings(settings)
                        }
                    ))
                }
                
                Section(header: Text("工作时间")) {
                    DatePicker("入职时间", selection: Binding(
                        get: {
                            DateFormatter.dateFormatter.date(from: settings.joinDate) ?? Date()
                        },
                        set: { newValue in
                            settings.joinDate = DateFormatter.dateFormatter.string(from: newValue)
                            UserDefaultsManager.shared.saveUserSettings(settings)
                        }
                    ), displayedComponents: .date)
                    
                    HStack {
                        Text("上班时间")
                        Spacer()
                        Text(settings.workStartTime)
                    }
                    
                    HStack {
                        Text("下班时间")
                        Spacer()
                        Text(settings.workEndTime)
                    }
                    
                    Button("设置工作日") {
                        showingWorkDaysSelection = true
                    }
                }
                
                Section(header: Text("外观")) {
                    Toggle("深色模式", isOn: $isDarkMode)
                }
                
                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                    }
                }
            }
            .navigationTitle("设置")
            .alert("设置月薪", isPresented: $showingSalaryInput) {
                TextField("月薪", text: Binding(
                    get: { String(format: "%.2f", settings.monthlySalary) },
                    set: { newValue in
                        if let salary = Double(newValue) {
                            settings.monthlySalary = salary
                            UserDefaultsManager.shared.saveUserSettings(settings)
                        }
                    }
                ))
                .keyboardType(.decimalPad)
                Button("确定") {}
                Button("取消", role: .cancel) {}
            }
            .sheet(isPresented: $showingWorkDaysSelection) {
                WorkDaysSelectionView(settings: $settings)
            }
        }
    }
}

struct WorkDaysSelectionView: View {
    @Binding var settings: UserSettings
    @Environment(\.dismiss) var dismiss
    
    let weekdays = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(1...7, id: \.self) { day in
                    Toggle(weekdays[day-1], isOn: Binding(
                        get: { settings.workDays.contains(day) },
                        set: { isOn in
                            if isOn {
                                settings.workDays.append(day)
                            } else {
                                settings.workDays.removeAll { $0 == day }
                            }
                            settings.workDays.sort()
                            UserDefaultsManager.shared.saveUserSettings(settings)
                        }
                    ))
                }
            }
            .navigationTitle("工作日设置")
            .navigationBarItems(trailing: Button("完成") {
                dismiss()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
