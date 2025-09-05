import Foundation

struct UserPrefs: Codable {
    var homeAddress: String = ""
    var workAddress: String = ""
    var weekdays: [Int] = [] // 1=Sun ... 7=Sat (أو حسب تقويمك)
}

final class UserPrefsStore {
    private let key = "UserPrefs"
    static let shared = UserPrefsStore()
    private init() {}

    func load() -> UserPrefs {
        guard let data = UserDefaults.standard.data(forKey: key),
              let prefs = try? JSONDecoder().decode(UserPrefs.self, from: data) else {
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
