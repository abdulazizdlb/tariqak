import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var prediction: DayPrediction?

    let engine: PredictionEngine
    let commute: Commute

    init(engine: PredictionEngine, commute: Commute) {
        self.engine = engine
        self.commute = commute
    }

    func loadToday() async {
        isLoading = true
        defer { isLoading = false }

        let today = Date()
        if let best = await engine.bestDeparture(
            origin: commute.home,
            destination: commute.work,
            day: today,
            window: commute.preferredWindow,
            stepMinutes: 15
        ) {
            self.prediction = best
        }
    }
}
