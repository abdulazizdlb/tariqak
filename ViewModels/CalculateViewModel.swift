import Foundation

@MainActor
final class CalculateViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var result: Prediction?
    @Published var errorMessage: String?

    private let engine: PredictionEngine
    private let commute: Commute

    init(engine: PredictionEngine, commute: Commute) {
        self.engine = engine
        self.commute = commute
    }

    func run() async {
        isLoading = true
        errorMessage = nil
        do {
            let r = try await engine.bestDeparture(for: commute)
            self.result = r
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
