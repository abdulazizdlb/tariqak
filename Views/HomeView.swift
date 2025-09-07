import SwiftUI

struct HomeView: View {
    @State private var homeAddress = ""
    @State private var workAddress = ""
    @State private var selectedDays: Set<Int> = [1, 2, 3, 4, 5] // الأحد-الخميس افتراضي
    @State private var windowStart = Date()
    @State private var windowEnd = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var showToast = false
    
    let onCalculate: (Commute) -> Void
    
    private let weekdays = [
        (0, "الأحد"), (1, "الاثنين"), (2, "الثلاثاء"), 
        (3, "الأربعاء"), (4, "الخميس"), (5, "الجمعة"), (6, "السبت")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Address Inputs
                addressSection
                
                // Days Selection
                daysSection
                
                // Time Window
                timeSection
                
                // Calculate Button
                calculateButton
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
        }
        .background(Theme.bg)
        .navigationTitle("طريقك")
        .environment(\.layoutDirection, .rightToLeft)
        .onAppear(perform: loadSavedPreferences)
        .toast(isPresented: $showToast, text: "تم حفظ التفضيلات")
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "car.fill")
                .font(.system(size: 48))
                .foregroundStyle(Theme.brandGradient)
            
            Text("احسب أفضل وقت للمغادرة")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(Theme.textPrimary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private var addressSection: some View {
        VStack(spacing: 16) {
            // Home Address
            VStack(alignment: .leading, spacing: 8) {
                Label("عنوان المنزل", systemImage: "house.fill")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                
                TextField("أدخل عنوان منزلك", text: $homeAddress)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
            // Work Address
            VStack(alignment: .leading, spacing: 8) {
                Label("عنوان العمل", systemImage: "building.2.fill")
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                
                TextField("أدخل عنوان عملك", text: $workAddress)
                    .textFieldStyle(CustomTextFieldStyle())
            }
        }
    }
    
    private var daysSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("أيام العمل", systemImage: "calendar")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(weekdays, id: \.0) { day, name in
                    DayToggleButton(
                        day: day,
                        name: name,
                        isSelected: selectedDays.contains(day)
                    ) {
                        if selectedDays.contains(day) {
                            selectedDays.remove(day)
                        } else {
                            selectedDays.insert(day)
                        }
                    }
                }
            }
        }
    }
    
    private var timeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("النافذة الزمنية", systemImage: "clock.fill")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("من:")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSubtle)
                    DatePicker("", selection: $windowStart, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("إلى:")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSubtle)
                    DatePicker("", selection: $windowEnd, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
            }
        }
    }
    
    private var calculateButton: some View {
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
            .clipShape(RoundedRectangle(cornerRadius: Theme.corner))
            .shadow(color: Theme.brandStart.opacity(0.3), radius: 8, y: 4)
        }
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
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
        savePreferences()
        
        // Navigate
        onCalculate(commute)
    }
    
    private func loadSavedPreferences() {
        let prefs = UserPrefsStore.shared.load()
        homeAddress = prefs.homeAddress
        workAddress = prefs.workAddress
        if !prefs.weekdays.isEmpty {
            selectedDays = Set(prefs.weekdays)
        }
    }
    
    private func savePreferences() {
        let prefs = UserPrefs(
            homeAddress: homeAddress.trimmingCharacters(in: .whitespaces),
            workAddress: workAddress.trimmingCharacters(in: .whitespaces),
            weekdays: Array(selectedDays)
        )
        UserPrefsStore.shared.save(prefs)
        showToast = true
    }
}

// MARK: - Supporting Views

struct DayToggleButton: View {
    let day: Int
    let name: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Theme.brandStart : Theme.textSubtle)
                Text(name)
                    .foregroundStyle(isSelected ? Theme.textPrimary : Theme.textSubtle)
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(isSelected ? Theme.brandStart.opacity(0.1) : Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.corner))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.corner)
                    .stroke(Theme.textSubtle.opacity(0.2), lineWidth: 1)
            )
    }
}

#Preview {
    NavigationView {
        HomeView { _ in }
    }
}
