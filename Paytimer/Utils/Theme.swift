import UIKit

enum Theme {
    static let primary = UIColor(hex: "#FFD700")
    static let textPrimary = UIColor(hex: "#1F2937")
    static let textSecondary = UIColor(hex: "#6B7280")
    static let background = UIColor(hex: "#FFFFFF")
    
    static let cardBackground = UIColor.white
    static let cardShadow = UIColor.black.withAlphaComponent(0.1)
    
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
} 