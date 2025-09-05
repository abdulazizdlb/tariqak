import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var home: String = ""
    @Published var work: String = ""
    @Published var selectedDays: Set<Int> = [1,2,3,4,5] // افتراضي: أحد–خميس

    @Published var windowStart: Date
    @Published var windowEnd: Date

    @Published var bestTime: Date?
    @Published var expectedDuration: Int = 20

    init() {
        let now = Date()
        self.windowStart = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: now) ?? now
        self.windowEnd   = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: now) ?? now
        self.bestTime = windowStart.addingTimeInterval(30 * 60)
    }

    var bestTimeString: String {
        guard let t = bestTime else { return "--:--" }
        let f = DateFormatter()
        f.locale = Locale(identifier: "ar")
        f.dateFormat = "h:mm a"
        return f.string(from: t)
    }

    // مؤقت للتجربة – لاحقًا نبدله بنداء HERE
    func calculateNow() {
        let step: TimeInterval = 10 * 60
        var items: [Date] = []
        var cur = windowStart
        while cur <= windowEnd { items.append(cur); cur = cur.addingTimeInterval(step) }
        bestTime = items[items.count / 2]
        expectedDuration = Int.random(in: 14...26)
    }
}
