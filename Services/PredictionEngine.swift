import Foundation

struct Prediction {
    let bestTime: Date
    let expectedDurationMinutes: Int
}

struct PredictionEngine {
    let provider: HereTrafficProvider
    
    /// حساب أفضل وقت للمغادرة
    func bestDeparture(for commute: Commute) async throws -> Prediction {
        // 1) Geocode addresses
        let homeCoords = try await provider.geocode(address: commute.homeAddress)
        let workCoords = try await provider.geocode(address: commute.workAddress)
        
        // 2) Calculate current route duration
        let currentDuration = try await provider.routeMinutes(from: homeCoords, to: workCoords)
        
        // 3) Calculate optimal departure time (simple algorithm)
        let bestTime = calculateOptimalTime(from: commute.windowStart, to: commute.windowEnd)
        
        return Prediction(
            bestTime: bestTime,
            expectedDurationMinutes: currentDuration
        )
    }
    
    private func calculateOptimalTime(from start: Date, to end: Date) -> Date {
        // Simple: suggest 15 minutes before midpoint
        let midpoint = start.addingTimeInterval((end.timeIntervalSince(start)) / 2)
        return midpoint.addingTimeInterval(-15 * 60)
    }
}
