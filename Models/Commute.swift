import Foundation

struct Commute: Identifiable, Hashable {
    var id = UUID()
    
    // عناوين يكتبها المستخدم
    var homeAddress: String = ""
    var workAddress: String = ""
    
    // توافق خلفي: إحداثيات اختيارية
    var home: Coordinate? = nil
    var work: Coordinate? = nil
    
    // وقت الانطلاق
    var departure: Date = Date()
    
    // أيام الأسبوع (اختيارية لتفادي الأخطاء)
    var selectedDays: Set<Int> = []
    
    // النافذة الزمنية (اختيارية لتفادي الأخطاء)
    var windowStart: Date = Date()
    var windowEnd: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
}
