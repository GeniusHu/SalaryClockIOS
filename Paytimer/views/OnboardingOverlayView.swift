import SwiftUI

struct OnboardingOverlayView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 半透明黑色背景
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                
                // 引导提示
                VStack {
                    HStack {
                        Spacer()
                        // 指向设置按钮的提示框
                        VStack(alignment: .trailing, spacing: 8) {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            Text("点击这里设置月薪和上下班时间")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.yellow.opacity(0.8))
                                .cornerRadius(8)
                        }
                        .padding(.trailing, 34)
                    }
                    .padding(.top, 60)
                    
                    Spacer()
                }
            }
            .onTapGesture {
                withAnimation {
                    isVisible = false
                    // 保存已显示过引导的标记
                    UserDefaults.standard.set(true, forKey: "hasShownOnboarding")
                }
            }
        }
    }
}
