import Foundation

struct HereTrafficProvider {
    private let apiKey: String = {
        if let key = ProcessInfo.processInfo.environment["HERE_API_KEY"] {
            return key
        } else {
            fatalError("❌ HERE_API_KEY not set (xcconfig / Actions secret).")
        }
    }()

    /// Geocode: يحوّل عنوان → إحداثيات
    func geocode(address: String) async throws -> (lat: Double, lng: Double) {
        let q = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://geocode.search.hereapi.com/v1/geocode?q=\(q)&apiKey=\(apiKey)")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let items = json?["items"] as? [[String: Any]],
              let pos = (items.first?["position"] as? [String: Any]),
              let lat = pos["lat"] as? Double,
              let lng = pos["lng"] as? Double else {
            throw NSError(domain: "Here.Geocode", code: 1, userInfo: [NSLocalizedDescriptionKey: "تعذّر استخراج الإحداثيات"])
        }
        return (lat, lng)
    }

    /// Route: يحسب مدّة الرحلة بالدقائق بين نقطتين
    func routeMinutes(from: (lat: Double, lng: Double),
                      to: (lat: Double, lng: Double)) async throws -> Int {
        let url = URL(string:
          "https://router.hereapi.com/v8/routes?transportMode=car&origin=\(from.lat),\(from.lng)&destination=\(to.lat),\(to.lng)&return=summary&apikey=\(apiKey)"
        )!

        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        guard let routes = json?["routes"] as? [[String: Any]],
              let sections = routes.first?["sections"] as? [[String: Any]],
              let summary = sections.first?["summary"] as? [String: Any],
              let durationSec = summary["duration"] as? Int else {
            throw NSError(domain: "Here.Route", code: 2, userInfo: [NSLocalizedDescriptionKey: "تعذّر استخراج مدة الرحلة"])
        }
        return max(1, durationSec / 60) // دقائق
    }
}
