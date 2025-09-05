import Foundation

struct Prediction {
    let bestDeparture: Date
    let note: String?
}

struct PredictionEngine {

    // NOTE: هذه دالة ستُستبدل لاحقًا بمنطق حقيقي.
    // الآن نرجّع قيمة ثابتة فقط لكي ينجح البناء على CI.
    func bestDepartureTime(for commute: Commute) async throws -> Prediction {
        // ارجع الآن موعدًا بعد 10 دقائق كتجربة
        let result = Prediction(bestDeparture: Date().addingTimeInterval(10 * 60),
                                note: "Stub result from CI build")
        return result
    }
}
