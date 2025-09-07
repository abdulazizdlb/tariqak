import SwiftUI

struct ResultView: View {
    let engine: PredictionEngine
    let commute: Commute
    
    @State private var isLoading = true
    @State private var prediction: Prediction?
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if isLoading {
                    loadingView
                } else if let p = prediction {
                    resultContent(p)
                } else if let error = errorMessage {
                    errorView(error)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(Theme.bg)
        .navigationTitle("النتيجة")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.layoutDirection, .rightToLeft)
        .task {
            await load()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.5)
                .tint(Theme.brandStart)
            
            Text("جاري حساب أفضل وقت للمغادرة...")
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
    
    private func resultContent(_ prediction: Prediction) -> some View {
        VStack(spacing: 24) {
            // Success Icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
            
            Text("تم الحساب بنجاح!")
                .font(.title2)
                .fontWeight(.bold)
            
            // Main Result Card
            VStack(spacing: 20) {
                Text("أفضل وقت للمغادرة")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text(prediction.bestTime.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.brandStart)
                
                Divider()
                
                HStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("\(prediction.expectedDurationMinutes)")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("دقيقة")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(spacing: 4) {
                        Text("الآن")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.orange)
                        Text("الحالة")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(24)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Route Info
            VStack(alignment: .leading, spacing: 16) {
                Label("تفاصيل الرحلة", systemImage: "map.fill")
                    .font(.headline)
                
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "house.fill")
                            .foregroundStyle(Theme.brandStart)
                        Text("من: \(commute.homeAddress)")
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundStyle(Theme.brandStart)
                        Text("إلى: \(commute.workAddress)")
                        Spacer()
                    }
                }
            }
            .padding(20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Spacer(minLength: 20)
        }
    }
    
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
            
            Text("حدث خطأ")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(error)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Button("إعادة المحاولة") {
                Task { await load() }
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.brandStart)
            
            Spacer()
        }
    }
    
    private func load() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await engine.bestDeparture(for: commute)
            prediction = result
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
