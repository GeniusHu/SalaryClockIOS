import SwiftUI

struct SettingsView: View {
    @State private var settings = UserDefaultsManager.shared.getUserSettings()
    @State private var showingSalaryInput = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本设置")) {
                    HStack {
                        Text("月薪")
                        Spacer()
                        Text(settings.hideAllMoney ? "****" : String(format: "¥%.2f", settings.monthlySalary))
                    }
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
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            return formatter.date(from: settings.joinDate) ?? Date()
                        },
                        set: { newValue in
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            settings.joinDate = formatter.string(from: newValue)
                            UserDefaultsManager.shared.saveUserSettings(settings)
                        }
                    ), displayedComponents: .date)
                }
                
                Section(header: Text("关于")) {
                    Text("版本 1.0.0")
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
                Button("确定", role: .none) {}
                Button("取消", role: .cancel) {}
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
} 