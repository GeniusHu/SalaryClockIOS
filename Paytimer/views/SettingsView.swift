import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @ObservedObject var earningsManager: EarningsManager

    @State private var monthlySalary: String = ""
    @State private var workStartTime: Date = Date()
    @State private var workEndTime: Date = Date()
    @State private var startDate: Date = Date()
    @State private var customWorkdays: [String: Bool] = [:]


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
                                Text(workStartTime.formattedTime(format: "HH:mm"))
                                    .foregroundColor(.gray)
                            }
                        }

                        Button(action: { activePicker = .endTime }) {
                            HStack {
                                Text("下班时间")
                                Spacer()
                                Text(workEndTime.formattedTime(format: "HH:mm"))
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    // 入职日期设置
                    Section(header: Text("入职日期")) {
                        Button(action: { activePicker = .startDate }) {
                            HStack {
                                Text("入职日期")
                                Spacer()
                                Text(startDate.formattedTime(format: "yyyy/MM/dd"))
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    // 工作日设置
                    Section(header: Text("工作日")) {
                        HStack {
                            ForEach(["周一", "周二", "周三", "周四", "周五", "周六", "周日"], id: \.self) { day in
                                Button(action: {
                                    customWorkdays[day, default: false].toggle()
                                }) {
                                    Text(day)
                                        .padding()
                                        .background(customWorkdays[day, default: false] ? Color.yellow : Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                        .foregroundColor(customWorkdays[day, default: false] ? .white : .black)
                                }
                            }
                        }
                    }

                    // 隐藏金额开关
                    Section {
                        Toggle("隐藏所有金额", isOn: .constant(false))
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
                    selectedTime: pickerType == .startTime ? $workStartTime : $workEndTime,
                               selectedDate: pickerType == .startTime ? $workStartTime : $workEndTime,
                               onDismiss: { activePicker = nil }
                )
                .zIndex(1) // 保证弹窗显示在最前
            }
        }
        .onAppear { loadSettings() }
    }

    private func loadSettings() {
        monthlySalary = String(format: "%.0f", earningsManager.monthlySalary)
        workStartTime = earningsManager.holidayManager.getWorkStartTime().toDate(format: "HH:mm") ?? Date()
        workEndTime = earningsManager.holidayManager.getWorkEndTime().toDate(format: "HH:mm") ?? Date()
        customWorkdays = earningsManager.holidayManager.loadCustomWorkdays()
        startDate = Date() // 可根据需要加载实际数据
    }

    private func saveSettings() {
        guard let salary = Double(monthlySalary) else { return }
        earningsManager.monthlySalary = salary
        earningsManager.holidayManager.saveWorkTimes(
            startTime: workStartTime.formattedTime(format: "HH:mm"),
            endTime: workEndTime.formattedTime(format: "HH:mm")
        )
        
        // 保存自定义工作日
           let workdayArray = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"].map { customWorkdays[$0] ?? false }
           earningsManager.holidayManager.saveCustomWorkdays(workdays: workdayArray)

           // 保存入职日期
           earningsManager.holidayManager.saveStartDate(startDate: startDate.formattedTime(format: "yyyy/MM/dd"))
           
        // 重新计算工作日和收入
        earningsManager.updateMonthlySalary(newSalary: salary)
        earningsManager.updateMonthlyAndYearlyEarnings()
        earningsManager.updateTodayEarnings()
       
        isPresented = false
    }
}
