import Foundation

public struct TimeWindow: Codable, Hashable {
    public var startMinutes: Int   // دقائق منذ منتصف الليل
    public var endMinutes: Int
    public init(startMinutes: Int, endMinutes: Int) {
        self.startMinutes = startMinutes
        self.endMinutes = endMinutes
    }
}

public enum Weekday: Int, CaseIterable, Codable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

public struct Commute: Identifiable, Codable, Equatable {
    public var id = UUID()
    public var home: Coordinate
    public var work: Coordinate
    /// نخزن الأيام كأرقام Weekday.rawValue لسهولة التخزين
    public var workingDays: Set<Int>
    public var preferredWindow: TimeWindow
}
