import SwiftUI

struct CountdownView: View {
    @State private var timeRemaining: TimeInterval = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("距离下班还有")
                .font(.headline)
            
            HStack(spacing: 20) {
                TimeBlock(value: Int(timeRemaining) / 3600, unit: "时")
                TimeBlock(value: (Int(timeRemaining) % 3600) / 60, unit: "分")
                TimeBlock(value: Int(timeRemaining) % 60, unit: "秒")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .onReceive(timer) { _ in
            updateTimeRemaining()
        }
    }
    
    private func updateTimeRemaining() {
        let calendar = Calendar.current
        let now = Date()
        
        // 获取今天的下班时间
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = 18 // 假设下班时间是18:00
        components.minute = 0
        components.second = 0
        
        guard let endTime = calendar.date(from: components) else { return }
        
        // 如果当前时间已经超过下班时间，显示0
        timeRemaining = max(0, endTime.timeIntervalSince(now))
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
} 
