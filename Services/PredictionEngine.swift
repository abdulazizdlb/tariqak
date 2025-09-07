import Foundation

struct Prediction {
    let bestTime: Date
    let expectedDurationMinutes: Int
    let confidence: String
    let alternativeTimes: [AlternativeTime]
    
    struct AlternativeTime {
        let time: Date
        let durationMinutes: Int
        let trafficLevel: String
    }
}

struct PredictionEngine {
    let provider: HereTrafficProvider
    
    /// حساب أفضل وقت للمغادرة مع بدائل متعددة
    func bestDeparture(for commute: Commute) async throws -> Prediction {
        // 1) Geocode addresses
        let homeCoords = try await provider.geocode(address: commute.homeAddress)
        let workCoords = try await provider.geocode(address: commute.workAddress)
        
        // 2) Calculate current route duration
        let currentDuration = try await provider.routeMinutes(from: homeCoords, to: workCoords)
        
        // 3) Generate prediction with some intelligence
        let bestTime = calculateOptimalDepartureTime(
            from: commute.windowStart,
            to: commute.windowEnd,
            baseDuration: currentDuration
        )
        
        // 4) Generate alternative times
        let alternatives = generateAlternativeTimes(
            around: bestTime,
            baseDuration: currentDuration
        )
        
        return Prediction(
            bestTime: bestTime,
            expectedDurationMinutes: currentDuration,
            confidence: determineConfidence(duration: currentDuration),
            alternativeTimes: alternatives
        )
    }
    
    private func calculateOptimalDepartureTime(from start: Date, to end: Date, baseDuration: Int) -> Date {
        // Simple algorithm: suggest departure 10 minutes before the middle of the window
        let midpoint = start.addingTimeInterval((end.timeIntervalSince(start)) / 2)
        return midpoint.addingTimeInterval(-10 * 60) // 10 minutes earlier
    }
    
    private func generateAlternativeTimes(around baseTime: Date, baseDuration: Int) -> [Prediction.AlternativeTime] {
        let alternatives: [Prediction.AlternativeTime] = [
            .init(time: baseTime.addingTimeInterval(-15 * 60), durationMinutes: baseDuration - 5, trafficLevel: "خفيف"),
            .init(time: baseTime.addingTimeInterval(15 * 60), durationMinutes: baseDuration + 10, trafficLevel: "متوسط"),
            .init(time: baseTime.addingTimeInterval(30 * 60), durationMinutes: baseDuration + 20, trafficLevel: "كثيف")
        ]
        return alternatives
    }
    
    private func determineConfidence(duration: Int) -> String {
        switch duration {
        case 0..<30: return "عالية"
        case 30..<60: return "متوسطة"
        default: return "منخفضة"
        }
    }
}
