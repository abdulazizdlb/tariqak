import SwiftUI

struct RootView: View {
    var body: some View {
        // قيم تجريبية مؤقتة (البيت والعمل في الرياض)
        let home = Coordinate(latitude: 24.7136, longitude: 46.6753)
        let work = Coordinate(latitude: 24.7743, longitude: 46.7386)

        let commute = Commute(
            home: home,
            work: work,
            workingDays: [2,3,4,5,6], // الأحد - الخميس
            preferredWindow: TimeWindow(startMinutes: 390, endMinutes: 510) // 6:30–8:30 ص
        )

        // المفروض Xcode يقرأ المفتاح من Info.plist ← $(HERE_API_KEY)
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "HERE_API_KEY") as? String ?? ""

        let provider = HereTrafficProvider(apiKey: apiKey)
        let engine = PredictionEngine(provider: provider)
        let vm = HomeViewModel(engine: engine, commute: commute)

        return HomeView(vm: vm)
    }
}
