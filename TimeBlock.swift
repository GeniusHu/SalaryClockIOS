import SwiftUI

struct TimeBlock: View {
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 70, height: 70)
        .background(Color(.systemYellow))
        .cornerRadius(8)
    }
} 