import Foundation

/// خدمة تستدعي HERE Routing API للحصول على وقت الرحلة
public struct HereTrafficProvider {
    let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    /// يحسب مدة الرحلة بالثواني بين نقطتين في وقت محدد
    public func travelTime(
        origin: Coordinate,
        destination: Coordinate,
        departure: Date
    ) async -> Int? {
        let urlString = "https://router.hereapi.com/v8/routes" +
        "?transportMode=car" +
        "&origin=\(origin.latitude),\(origin.longitude)" +
        "&destination=\(destination.latitude),\(destination.longitude)" +
        "&departureTime=\(iso8601(departure))" +
        "&return=summary" +
        "&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode(RouteResponse.self, from: data),
               let duration = decoded.routes.first?.sections.first?.summary.duration {
                return duration
            }
        } catch {
            print("HERE API error: \(error)")
        }
        return nil
    }
    
    private func iso8601(_ date: Date) -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f.string(from: date)
    }
}

/// نموذج للرد من HERE
struct RouteResponse: Codable {
    struct Route: Codable {
        struct Section: Codable {
            struct Summary: Codable { let duration: Int }
            let summary: Summary
        }
        let sections: [Section]
    }
    let routes: [Route]
}
