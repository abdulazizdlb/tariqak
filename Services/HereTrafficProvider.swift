import Foundation

struct HereTrafficProvider {
    private let apiKey = "YOUR_HERE_API_KEY"

    func geocode(address: String) async throws -> (lat: Double, lng: Double) {
        let query = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://geocode.search.hereapi.com/v1/geocode?q=\(query)&apiKey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let items = json?["items"] as? [[String: Any]],
              let pos = (items.first?["position"] as? [String: Double]),
              let lat = pos["lat"], let lng = pos["lng"] else {
            throw NSError(domain: "GeocodeError", code: 1)
        }
        return (lat, lng)
    }

    func route(from: (lat: Double, lng: Double),
               to: (lat: Double, lng: Double)) async throws -> Int {
        let url = URL(string:
            "https://router.hereapi.com/v8/routes?transportMode=car&origin=\(from.lat),\(from.lng)&destination=\(to.lat),\(to.lng)&return=summary&apikey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let routes = json?["routes"] as? [[String: Any]],
              let sections = routes.first?["sections"] as? [[String: Any]],
              let summary = sections.first?["summary"] as? [String: Any],
              let duration = summary["duration"] as? Int else {
            throw NSError(domain: "RouteError", code: 2)
        }
        return duration / 60 // دقائق
    }
}
