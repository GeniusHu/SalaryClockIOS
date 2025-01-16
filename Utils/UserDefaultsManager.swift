import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    // MARK: - UserSettings
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
    
    // MARK: - Theme
    func saveThemeMode(_ isDark: Bool) {
        defaults.set(isDark, forKey: UserDefaultsKeys.themeMode)
    }
    
    func getThemeMode() -> Bool {
        return defaults.bool(forKey: UserDefaultsKeys.themeMode)
    }
} 