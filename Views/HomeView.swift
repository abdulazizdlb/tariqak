import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if vm.isLoading {
                    ProgressView("جاري الحساب...")
                } else if let p = vm.prediction {
                    Text("أفضل وقت اليوم").font(.title2)
                    Text(p.recommendedDeparture.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 28, weight: .bold))
                    Text("المدة المتوقعة: \(p.expectedDurationSeconds/60) دقيقة")
                        .foregroundColor(.secondary)
                } else {
                    Text("اضغط الزر لحساب أفضل وقت")
                }

                Button("احسب الآن") {
                    Task { await vm.loadToday() }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("طريقك")
        }
    }
}
