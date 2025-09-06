import Foundation

struct HereTrafficProvider {
    // نقرأ المفتاح من Secrets.xcconfig → بيكون متاح كـ Environment Variable
    private let apiKey: String = {
        if let key = ProcessInfo.processInfo.environment["HERE_API_KEY"] {
            return key
        } else {
            fatalError("❌ HERE_API_KEY not set in Secrets.xcconfig or scheme environment.")
        }
    }()

    /// تحويل عنوان نصي إلى إحداثيات (lat, lng)
    func geocode(address: String) async throws -> (lat: Double, lng: Double) {
        let query = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://geocode.search.hereapi.com/v1/geocode?q=\(query)&apiKey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        guard let items = json?["items"] as? [[String: Any]],
              let pos = (items.first?["position"] as? [String: Double]),
              let lat = pos["lat"], let lng = pos["lng"] else {
            throw NSError(domain: "HereTrafficProvider", code: 1, userInfo: [NSLocalizedDescriptionKey: "فشلنا في استخراج الإحداثيات"])
        }
        return (lat, lng)
    }

    /// حساب مدة الرحلة (دقائق) بين نقطتين
    func route(from: (lat: Double, lng: Double),
               to: (lat: Double, lng: Double)) async throws -> Int {
        let url = URL(string:
            "https://router.hereapi.com/v8/routes?transportMode=car&origin=\(from.lat),\(from.lng)&destination=\(to.lat),\(to.lng)&return=summary&apikey=\(apiKey)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let
