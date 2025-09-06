import Foundation

struct Prediction {
    let bestTime: Date
    let expectedDurationMinutes: Int
}

struct PredictionEngine {
    private let provider = HereTrafficProvider()

    func bestDeparture(for commute: Commute) async throws -> Prediction {
        // 1. Geocode addresses
        let from = try await provider.geocode(address: commute.homeAddress)
        let to   = try await provider.geocode(address: commute.workAddress)

        // 2. جرب وقت الرحلة الحالي (تقدر توسع لاحقًا للتاريخية)
        let minutes = try await provider.route(from: from, to: to)

        return Prediction(bestTime: Date(), expectedDurationMinutes: minutes)
    }
}
