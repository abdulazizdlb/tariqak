import Foundation
import CoreLocation

public struct Coordinate: Codable, Hashable {
    public let latitude: Double
    public let longitude: Double
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    public var cl: CLLocationCoordinate2D { .init(latitude: latitude, longitude: longitude) }
}
