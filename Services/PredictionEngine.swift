import Foundation

/// محرك بسيط لاختيار أفضل وقت انطلاق داخل نافذة زمنية.
/// الإصدار هذا “ستَب” كي ينجح البناء على CI حتى لو فشل الاتصال بـ HERE.
/// لاحقًا نقدر نطوّره لاستدعاء HereTrafficProvider فعليًا وحساب المدة الأدنى.
struct PredictionEngine {
    // نخزّن الـprovider للاستخدام لاحقًا (ممكن حالياً ما نستخدمه)
    let provider: HereTrafficProvider

    init(provider: HereTrafficProvider) {
        self.provider = provider
    }

    /// يرجّع أفضل موعد انطلاق في اليوم المحدد داخل النافذة.
    /// حالياً يُرجّع المنتصف تقريبًا + مدة ثابتة كتجربة، ولو احتجنا نقدر نبدّل المنطق لاحقًا.
    func bestDeparture(
        origin: Coordinate,
        destination: Coordinate,
        day: Date,
        window: TimeWindow,
        stepMinutes: Int
    ) async -> DayPrediction? {

        // نحسب وقت بداية/نهاية النافذة على تاريخ اليوم
        let cal = Calendar(identifier: .gregorian)
        guard
            let start = cal.date(bySettingHour: window.startMinutes / 60,
                                 minute: window.startMinutes % 60,
                                 second: 0,
                                 of: day),
            let end = cal.date(bySettingHour: window.endMinutes / 60,
                               minute: window.endMinutes % 60,
                               second: 0,
                               of: day),
            start < end
        else {
            return nil
        }

        // نختار منتصف النافذة كتجربة أولية
        let mid = start.addingTimeInterval(end.timeIntervalSince(start) / 2.0)

        // مدة افتراضية للتجربة (20 دقيقة). لاحقًا نستبدلها بنتيجة HERE.
        let expectedDurationSec = 20 * 60

        // ممكن نجرّب استدعاء HERE بشكل اختياري.
        // لو عندنا مفتاح صحيح ونفذت الدالة بنجاح، نقدر نحدث expectedDurationSec.
        // (نحافظ على البناء حتى لو فشل الاتصال)
        // مثال (معلّق لأنه يعتمد على تنفيذ HereTrafficProvider):
        /*
        do {
            if let secs = try await provider.travelTimeSeconds(
                origin: origin,
                destination: destination,
                departure: mid
            ) {
                expectedDurationSec = secs
            }
        } catch {
            // نتجاهل الخطأ ونستخدم القيمة الافتراضية
        }
        */

        return DayPrediction(
            date: day,
            recommendedDeparture: mid,
            expectedDurationSeconds: expectedDurationSec,
            confidence: .low
        )
    }
}
