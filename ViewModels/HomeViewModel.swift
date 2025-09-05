import Foundation
import SwiftUI

final class HomeViewModel: ObservableObject {
    // إدخالات المستخدم
    @Published var home: String = ""
    @Published var work: String = ""
    @Published var selectedDays: Set<Int> = [1,2,3,4,5] // افتراضي: أحاد → خميس

    // نافذة الوقت
    @Published var windowStart: Date
    @Published var windowEnd: Date

    // ناتج العرض
    @Published var bestTime: Date?
    @Published var expectedDuration: Int = 20

    private let calendar = Calendar(identifier: .gregorian)

    init() {
        // افتراض 7:00 إلى 8:30
        let now = Date()
        let start = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: now) ?? now
        let end = Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: now) ?? now
        self.windowStart = start
        self.windowEnd = end

        // قيمة أولية ظاهرة
        self.bestTime = start.addingTimeInterval(30 * 60)
    }

    var bestTimeString: String {
        guard let t = bestTime else { return "--:--" }
        let f = DateFormatter()
        f.locale = Locale(identifier: "ar")
        f.dateFormat = "h:mm a"
        return f.string(from: t)
    }

    // حساب مبدئي (Mock) — لاحقًا سنبدله بنداء HERE API
    func calculateNow() {
        // مثال: نجرب كل 10 دقائق ضمن النافذة ونختار منتصفها كوقت أمثل مؤقتًا
        let step: TimeInterval = 10 * 60
        var times: [Date] = []
        var cur = windowStart
        while cur <= windowEnd {
            times.append(cur)
            cur = cur.addingTimeInterval(step)
        }
        bestTime = times[times.count / 2]
        expectedDuration = Int.random(in: 14...26) // مؤقت للتجربة
    }
}
