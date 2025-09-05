import SwiftUI

struct RootView: View {
    // وفّر محرّك التنبؤ مرة واحدة
    private let engine = PredictionEngine(provider: HereTrafficProvider())

    var body: some View {
        NavigationStack {
            HomeView(onCalculate: { commute in
                // عند الضغط "احسب الآن" انتقل لشاشة النتيجة
                pathToResult(commute: commute)
            })
            .navigationTitle("الرئيسية")
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    @ViewBuilder
    private func pathToResult(commute: Commute) -> some View {
        // التفاف سريع للانتقال
        NavigationLink("", destination: ResultView(engine: engine, commute: commute))
            .hidden()
    }
}
