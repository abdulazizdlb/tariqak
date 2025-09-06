import Foundation

struct Commute: Identifiable, Hashable {
    var id = UUID()

    // عناوين يكتبها المستخدم – مستخدمة في PredictionEngine
    var homeAddress: String = ""
    var workAddress: String = ""

    // توافق خلفي: لو كنت تستخدم إحداثيات سابقًا خلّيناها اختيارية
    var home: Coordinate? = nil
    var work: Coordinate? = nil

    // وقت الانطلاق (إن احتجته)
    var departure: Date = Date()
}
