import Foundation

struct UserSettings: Codable {
    var monthlySalary: Double = 10000
    var workStartTime: String = "09:00"
    var workEndTime: String = "18:00"
    var joinDate: String = "2024-01-01"
    var workDays: [Int] = [1, 2, 3, 4, 5]  // 1-7 代表周一到周日
    var hideAllMoney: Bool = false
    
    static var `default`: UserSettings {
        return UserSettings()
    }
} 