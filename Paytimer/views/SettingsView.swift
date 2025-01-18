import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @ObservedObject var appData = AppDataManager.shared // 全局数据管理器

    // 本地状态
    @State private var monthlySalary: String = ""
    @State private var workStartTime: Date = Date()
    @State private var workEndTime: Date = Date()
    @State private var startDate: Date = Date()
    @State private var customWorkdays: [Bool] = [true, true, true, true, true, false, false]

    // 弹窗控制
    @State private var activePicker: PickerType? = nil

    enum PickerType {
        case startTime
        case endTime
        case startDate
    }

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // 顶部标题栏
                HStack {
                    Text("设置")
                        .font(.system(size: 18, weight: .bold))
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18))
                    }
                }
                .padding()

                // 表单部分
                Form {
                    // 月薪设置
                    Section(header: Text("薪资设置")) {
                        TextField("月薪", text: $monthlySalary)
                            .keyboardType(.numberPad)
                            .onChange(of: monthlySalary) { newValue in
                                monthlySalary = newValue.filter { $0.isNumber }
                            }
                    }

                    // 上下班时间设置
                    Section(header: Text("工作时间")) {
                        Button(action: { activePicker = .startTime }) {
                            HStack {
                                Text("上班时间")
                                Spacer()
                                Text(workStartTime.formattedTime("HH:mm"))
                                    .foregroundColor(.gray)
                            }
                        }

                        Button(action: { activePicker = .endTime }) {
                            HStack {
                                Text("下班时间")
                                Spacer()
                                Text(workEndTime.formattedTime("HH:mm"))
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    // 入职日期设置
//                    Section(header: Text("入职日期")) {
//                        Button(action: { activePicker = .startDate }) {
//                            HStack {
//                                Text("入职日期")
//                                Spacer()
//                                Text(startDate.formattedTime("yyyy/MM/dd"))
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }

                    // 工作日设置
//                    Section(header: Text("工作日")) {
//                        HStack {
//                            ForEach(0..<7, id: \.self) { index in
//                                Button(action: {
//                                    customWorkdays[index].toggle()
//                                }) {
//                                    Text(["周一", "周二", "周三", "周四", "周五", "周六", "周日"][index])
//                                        .padding()
//                                        .background(customWorkdays[index] ? Color.yellow : Color.gray.opacity(0.2))
//                                        .cornerRadius(8)
//                                        .foregroundColor(customWorkdays[index] ? .white : .black)
//                                }
//                            }
//                        }
//                    }

                    // 隐藏金额开关
                    Section {
                        Toggle("隐藏所有金额", isOn: $appData.hideAllAmounts)
                    }
                }

                // 保存按钮
                Button(action: saveSettings) {
                    Text("保存")
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }

            // 弹出的时间选择器或日期选择器
            if let pickerType = activePicker {
                PickerOverlay(
                    pickerType: pickerType,
                    selectedTime: pickerType == .startTime || pickerType == .endTime
                        ? (pickerType == .startTime ? $workStartTime : $workEndTime)
                        : .constant(Date()), // 提供一个默认的空绑定以避免 nil 问题
                    selectedDate: pickerType == .startDate ? $startDate : .constant(appData.joinDate),
                    onDismiss: { activePicker = nil }
                )
                .zIndex(1) // 保证弹窗显示在最前
            }
        }
        .onAppear { loadSettings() }
    }

    private func loadSettings() {
        // 从 AppDataManager 加载数据
        monthlySalary = String(format: "%.0f", appData.monthlySalary)
        workStartTime = appData.workStartTime
        workEndTime = appData.workEndTime
        customWorkdays = appData.customWorkdays
        startDate = appData.joinDate
    }

    private func saveSettings() {
        guard let salary = Double(monthlySalary) else { return }
        
        appData.updateMonthlySalary(newSalary: salary)
        appData.updateWorkTimes(startTime: workStartTime, endTime: workEndTime)
        
        // 使用自定义工作日布尔数组直接更新
            let customWorkdaysBool = customWorkdays // 直接使用状态数
        appData.updateCustomWorkdays(workdays: customWorkdaysBool)
        
        appData.updateJoinDate(newDate: startDate)
        
        // 更新收入和倒计时目标
        appData.updateEarningsAndTargetTime()
        
        // 关闭设置页面
        isPresented = false
    }
}
