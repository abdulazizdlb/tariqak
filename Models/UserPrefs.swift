import Foundation

/// بيانات تفضيلات المستخدم (MVP)
struct UserPrefs: Codable {
    var homeAddress: String = ""
    var workAddress: String = ""
    /// نخزّن الأيام كأرقام (0=السبت، 1=الأحد، … 6=الجمعة)
    var weekdays: [Int] = []
}

/// مخزن بسيط فوق UserDefaults
final class UserPrefsStore {
    static let shared = UserPrefsStore()
    private init() {}

    private let key = "UserPrefs"

    func load() -> UserPrefs {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let prefs = try? JSONDecoder().decode(UserPrefs.self, from: data)
        else {
            return UserPrefs()
        }
        return prefs
    }

    func save(_ prefs: UserPrefs) {
        if let data = try? JSONEncoder().encode(prefs) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
