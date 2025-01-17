import SwiftUI

struct PickerOverlay: View {
    let pickerType: SettingsView.PickerType
    @Binding var selectedTime: Date
    @Binding var selectedDate: Date
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            // 半透明背景，点击关闭弹窗
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            // 弹窗内容，贴在底部
            VStack(spacing: 0) {
                // 顶部操作栏
                HStack {
                    Spacer()
                    Button("确定") {
                        onDismiss()
                    }
                    .padding()
                    .foregroundColor(Color(hex: "#FFD700"))
                }
                Divider()

                // 时间或日期选择器
                if pickerType == .startDate {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                } else {
                    DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
            }
            .frame(height: 300) // 固定高度
            .background(Color.white)
            .cornerRadius(16, corners: [.topLeft, .topRight,.bottomLeft,.bottomRight])
            .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: -5)
            .frame(maxWidth: .infinity)
            .padding(.bottom) // 增加底部间距，适配安全区域
            .transition(.move(edge: .bottom)) // 从底部滑入
            .animation(.easeInOut, value: pickerType)
        }
    }
}
