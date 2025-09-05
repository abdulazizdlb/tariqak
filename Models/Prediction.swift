import Foundation

public enum Confidence: String, Codable { case high, medium, low }

public struct DayPrediction: Identifiable, Codable {
    public var id = UUID()
    public var date: Date
    public var recommendedDeparture: Date
    public var expectedDurationSeconds: Int
    public var confidence: Confidence
}
