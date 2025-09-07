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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("تم") {
                    dismiss()
                }
            }
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
                .foregroundStyle(Theme.textSubtle)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 8) {
                Text("🔍 البحث عن الإحداثيات")
                Text("🚗 حساب مدة الرحلة")
                Text("📊 تحليل البيانات")
            }
            .font(.subheadline)
            .foregroundStyle(Theme.textSubtle)
            
            Spacer()
        }
    }
    
    private func resultContent(_ prediction: Prediction) -> some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                
                Text("تم الحساب بنجاح!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Theme.textPrimary)
            }
            
            // Main Result Card
            resultCard(prediction)
            
            // Route Info Card
            routeInfoCard()
            
            // Action Buttons
            actionButtons()
            
            Spacer(minLength: 20)
        }
    }
    
    private func resultCard(_ prediction: Prediction) -> some View {
        VStack(spacing: 20) {
            Text("أفضل وقت للمغادرة")
                .font(.headline)
                .foregroundStyle(Theme.textSubtle)
            
            Text(prediction.bestTime.formatted(date: .omitted, time: .shortened))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.brandStart)
            
            Divider()
            
            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("\(prediction.expectedDurationMinutes)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.textPrimary)
                    Text("دقيقة")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSubtle)
                }
                
                VStack(spacing: 4) {
                    Text("الآن")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                    Text("الحالة")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSubtle)
                }
            }
        }
        .padding(24)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.corner))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
    
    private func routeInfoCard() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("تفاصيل الرحلة", systemImage: "map.fill")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)
            
            VStack(spacing: 12) {
                routeRow(icon: "house.fill", title: "من", subtitle: commute.homeAddress)
                routeRow(icon: "building.2.fill", title: "إلى", subtitle: commute.workAddress)
                routeRow(icon: "clock.fill", title: "النافذة الزمنية", 
                        subtitle: "\(commute.windowStart.formatted(date: .omitted, time: .shortened)) - \(commute.windowEnd.formatted(date: .omitted, time: .shortened))")
            }
        }
        .padding(20)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.corner))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
    
    private func routeRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Theme.brandStart)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSubtle)
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(Theme.textPrimary)
            }
            
            Spacer()
        }
    }
    
    private func actionButtons() -> some View {
        VStack(spacing: 12) {
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "bell.fill")
                    Text("تذكيرني بالمغادرة")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.brandGradient)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                    Text("مشاركة النتيجة")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.textSubtle.opacity(0.1))
                .foregroundStyle(Theme.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
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
                .foregroundStyle(Theme.textPrimary)
            
            Text(error)
                .font(.body)
                .foregroundStyle(Theme.textSubtle)
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

#Preview {
    NavigationView {
        ResultView(
            engine: PredictionEngine(provider: HereTrafficProvider()),
            commute: Commute(homeAddress: "الرياض", workAddress: "الخبر")
        )
    }
}
