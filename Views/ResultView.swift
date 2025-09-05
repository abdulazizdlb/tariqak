import SwiftUI

struct ResultView: View {
    @StateObject private var vm: CalculateViewModel

    init(engine: PredictionEngine, commute: Commute) {
        _vm = StateObject(wrappedValue: CalculateViewModel(engine: engine, commute: commute))
    }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            Group {
                if vm.isLoading {
                    ProgressView("جارِ الحساب...")
                        .progressViewStyle(.circular)
                        .font(.headline)
                } else if let res = vm.result {
                    VStack(alignment: .trailing, spacing: 16) {
                        Text("أفضل وقت للخروج")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .trailing)

                        // بطاقة النتيجة
                        VStack(alignment: .trailing, spacing: 8) {
                            Text(res.bestTime.formatted(date: .omitted, time: .shortened))
                                .font(.system(size: 36, weight: .bold))
                            Text("المدة المتوقعة: \(res.expectedDurationMinutes) دقيقة")
                                .foregroundColor(Theme.textSubtle)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .background(Theme.card)
                        .cornerRadius(Theme.corner)
                        .shadow(color: .black.opacity(0.08), radius: Theme.cardShadow, y: 4)

                        Spacer()
                    }
                    .padding(20)
                } else if let err = vm.errorMessage {
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(err).multilineTextAlignment(.center)
                    }
                    .padding(20)
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .task { await vm.run() }
        .navigationTitle("النتيجة")
        .navigationBarTitleDisplayMode(.inline)
    }
}
