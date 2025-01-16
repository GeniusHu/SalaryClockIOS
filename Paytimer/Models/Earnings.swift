import Foundation

struct Earnings {
    var today: Double
    var month: Double
    var year: Double
    
    static var zero: Earnings {
        return Earnings(today: 0, month: 0, year: 0)
    }
} 