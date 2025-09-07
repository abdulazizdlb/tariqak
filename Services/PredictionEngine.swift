import Foundation

struct Prediction {
    let bestTime: Date
    let expectedDurationMinutes: Int
}

struct PredictionEngine {
    let provider: HereTrafficProvider
    
    func bestDeparture(for commute: Commute) async throws -> Prediction {
        let homeCoords = try await provider.geocode(address: commute.homeAddress)
        let workCoords = try await provider.geocode(address: commute.workAddress)
        let currentDuration = try await provider.routeMinutes(from: homeCoords, to: workCoords)
        
        return Prediction(
            bestTime: Date().addingTimeInterval(-15 * 60), // 15 minutes from now
            expectedDurationMinutes: currentDuration
        )
    }
}
