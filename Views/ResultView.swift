import SwiftUI

struct ResultView: View {
    let engine: PredictionEngine
    let commute: Commute

    @State private var isLoading = true
    @State private var prediction: Prediction?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if isLoading {
                ProgressView("جاري الحساب…")
            } else if let p = prediction {
                VStack(spacing: 16) {
                    Text("أفضل وقت للمغادرة")
                        .font(.title2).bold()

                    Text(p.bestTime.formatted(date: .omitted, time: .shortened))
                        .font(.title3)

                    Text("المدة المتوقعة: \(p.expectedDurationMinutes) دقيقة")
                        .font(.body)

                    Spacer()
                }
                .padding()
            } else if let msg = errorMessage {
                VStack(spacing: 12) {
                    Text("حدث خطأ")
                        .font(.title3).bold()
                    Text(msg).multilineTextAlignment(.center)
                }
                .padding()
            }
        }
        .task {
            await load()
        }
        .navigationTitle("النتيجة")
        .environment(\.layoutDirection, .rightToLeft)
    }

    private func load() async {
        do {
            isLoading = true
            errorMessage = nil
            prediction = try await engine.bestDeparture(for: commute)
        } catch {
            errorMessage = (error as NSError).localizedDescription
        }
        isLoading = false
    }
}
