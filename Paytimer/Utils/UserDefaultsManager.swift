import Foundation

enum UserDefaultsKeys {
    static let userSettings = "userSettings"
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    func saveUserSettings(_ settings: UserSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: UserDefaultsKeys.userSettings)
        }
    }
    
    func getUserSettings() -> UserSettings {
        if let data = defaults.data(forKey: UserDefaultsKeys.userSettings),
           let settings = try? JSONDecoder().decode(UserSettings.self, from: data) {
            return settings
        }
        return .default
    }
} 