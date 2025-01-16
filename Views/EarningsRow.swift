import SwiftUI

struct EarningsRow: View {
    let title: String
    let amount: Double
    let hideAmount: Bool
    @State private var localHideAmount: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(localHideAmount ? "****" : String(format: "¥%.2f", amount))
                .bold()
                .foregroundColor(.orange)
            Button(action: {
                localHideAmount.toggle()
            }) {
                Image(systemName: localHideAmount ? "eye.slash.fill" : "eye.slash")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear {
            localHideAmount = hideAmount
        }
        .onChange(of: hideAmount) { newValue in
            localHideAmount = newValue
        }
    }
} 