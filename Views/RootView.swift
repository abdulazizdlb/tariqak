import SwiftUI

struct RootView: View {
    private let engine = PredictionEngine(provider: HereTrafficProvider())
    @State private var navCommute: Commute? = nil

    var body: some View {
        NavigationStack {
            HomeView(onCalculate: { commute in
                navCommute = commute
            })
            .navigationTitle("الرئيسية")
            .navigationDestination(item: $navCommute) { commute in
                ResultView(engine: engine, commute: commute)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
