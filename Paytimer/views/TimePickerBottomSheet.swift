import SwiftUI

struct TimePickerBottomSheet: View {
    @Binding var selectedTime: Date
    var title: String
    var onConfirm: () -> Void

    var body: some View {
        VStack {
            // 顶部标题和确认按钮
            HStack {
                Text(title)
                    .font(.headline)
                    .padding(.leading)
                Spacer()
                Button(action: onConfirm) {
                    Text("确定")
                        .foregroundColor(Color(hex: "#FFD700"))
                }
                .padding(.trailing)
            }
            .padding(.vertical, 10)

            Divider()

            // 时间选择器
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()

            Spacer()
        }
        .frame(height: 300)             // 底部弹出的高度
        .background(Color.white)       // 背景颜色
        .cornerRadius(16, corners: [.topLeft, .topRight])  // 只圆角顶部
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: -5)
    }
}
