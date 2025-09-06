import Foundation

struct Prediction {
    let bestTime: Date
    let expectedDurationMinutes: Int
}

struct PredictionEngine {
    let provider: HereTrafficProvider

    /// نسخة أولية: نحسب رحلة "الآن" (لاحقًا نوسعها للبيانات التاريخية)
    func bestDeparture(for commute: Commute) async throws -> Prediction {
        // 1) Geocode
        let home = try await provider.geocode(address: commute.homeAddress)
        let work = try await provider.geocode(address: commute.workAddress)

        // 2) Route الآن
        let minutes = try await provider.routeMinutes(from: home, to: work)

        // 3) نرجّع نتيجة مبدئية
        return Prediction(bestTime: Date(), expectedDurationMinutes: minutes)
    }
}
