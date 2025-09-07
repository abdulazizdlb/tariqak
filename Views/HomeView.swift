import SwiftUI

struct HomeView: View {
    @State private var homeAddress = ""
    @State private var workAddress = ""
    @State private var selectedDays: Set<Int> = [1, 2, 3, 4, 5] // الأحد-الخميس
    @State private var windowStart = Date()
    @State private var windowEnd = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var showToast = false
    
    let onCalculate: (Commute) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.brandGradient)
                    
                    Text("احسب أفضل وقت للمغادرة")
                        .font(.title2)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Address Inputs
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("عنوان المنزل", systemImage: "house.fill")
                            .font(.headline)
                        
                        TextField("أدخل عنوان منزلك", text: $homeAddress)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label("عنوان العمل", systemImage: "building.2.fill")
                            .font(.headline)
                        
                        TextField("أدخل عنوان عملك", text: $workAddress)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                // Simple Days Selection
                VStack(alignment: .leading, spacing: 12) {
                    Label("أيام العمل", systemImage: "calendar")
                        .font(.headline)
                    
                    Text("الأيام المختارة: \(selectedDays.count) أيام")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                // Time Selection
                VStack(alignment: .leading, spacing: 16) {
                    Label("النافذة الزمنية", systemImage: "clock.fill")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("من:")
                                .font(.subheadline)
                            DatePicker("", selection: $windowStart, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("إلى:")
                                .font(.subheadline)
                            DatePicker("", selection: $windowEnd, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }
                    }
                }
                
                // Calculate Button
                Button(action: handleCalculate) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("احسب الآن")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.brandGradient)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1.0 : 0.6)
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .background(Theme.bg)
        .navigationTitle("طريقك")
        .environment(\.layoutDirection, .rightToLeft)
        .toast(isPresented: $showToast, text: "تم حفظ التفضيلات")
    }
    
    private var isFormValid: Bool {
        !homeAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        !workAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        !selectedDays.isEmpty
    }
    
    private func handleCalculate() {
        let commute = Commute(
            homeAddress: homeAddress.trimmingCharacters(in: .whitespaces),
            workAddress: workAddress.trimmingCharacters(in: .whitespaces),
            selectedDays: selectedDays,
            windowStart: windowStart,
            windowEnd: windowEnd
        )
        
        // Save preferences
        let prefs = UserPrefs(
            homeAddress: homeAddress,
            workAddress: workAddress,
            weekdays: Array(selectedDays)
        )
        UserPrefsStore.shared.save(prefs)
        showToast = true
        
        // Navigate
        onCalculate(commute)
    }
}
