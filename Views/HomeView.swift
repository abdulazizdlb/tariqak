import SwiftUI

struct HomeView: View {
    // مدخلات
    @State private var homeAddress: String = ""
    @State private var workAddress: String = ""
    @State private var selectedDays: Set<String> = []
    @State private var showSavedToast = false

    private let days = ["السبت","الأحد","الاثنين","الثلاثاء","الأربعاء","الخميس","الجمعة"]
    private let grid  = [GridItem(.adaptive(minimum: 84), spacing: 10, alignment: .trailing)]

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .trailing, spacing: 20) {

                    // عنوان علوي أنيق
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("طريقك")
                                .font(.system(size: 28, weight: .bold))
                            Text("خطط وقت خروجك الذكي")
                                .foregroundColor(Theme.textSubtle)
                        }
                    }

                    // كارت المدخلات
                    VStack(alignment: .trailing, spacing: 16) {
                        LabeledField(title: "منزلي", placeholder: "ادخل عنوان المنزل", text: $homeAddress, icon: "house.fill")
                        LabeledField(title: "عملي",  placeholder: "ادخل عنوان العمل",  text: $workAddress, icon: "briefcase.fill")

                        VStack(alignment: .trailing, spacing: 10) {
                            Text("أيام الذهاب")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                            LazyVGrid(columns: grid, alignment: .trailing, spacing: 10) {
                                ForEach(days, id: \.self) { day in
                                    DayPill(title: day, isOn: selectedDays.contains(day)) {
                                        toggleDay(day)
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Theme.card)
                    .cornerRadius(Theme.corner)
                    .shadow(color: .black.opacity(0.08), radius: Theme.cardShadow, y: 4)

                    // زر حفظ بتدرّج لوني
                    Button(action: saveInputs) {
                        HStack(spacing: 8) {
                            Image(systemName: "tray.and.arrow.down.fill")
                            Text("حفظ")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundColor(.white)
                        .background(Theme.brandGradient)
                        .cornerRadius(14)
                        .shadow(color: Theme.brandEnd.opacity(0.25), radius: 12, y: 6)
                    }
                    .buttonStyle(.plain)
                }
                .padding(20)
            }

            // توست أنيق
            if showSavedToast {
                Label("تم حفظ بياناتك", systemImage: "checkmark.seal.fill")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .shadow(radius: 8)
                    .padding(.bottom, 28)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        // اتجاه RTL
        .environment(\.layoutDirection, .rightToLeft)
        .animation(.spring(response: 0.35, dampingFraction: 0.9), value: showSavedToast)
        .onAppear(perform: loadSaved)
    }

    // MARK: - Actions
    private func toggleDay(_ day: String) {
        if selectedDays.contains(day) { selectedDays.remove(day) }
        else { selectedDays.insert(day) }
    }

    private func saveInputs() {
        // احفظ (عدّل حسب مخزنك إن لزم)
        UserPrefsStore.shared.save(
            homeAddress: homeAddress,
            workAddress: workAddress,
            days: Array(selectedDays).sorted(by: daySort)
        )

        // هابتك بسيط
        #if os(iOS)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        #endif

        showSavedToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            showSavedToast = false
        }
    }

    private func loadSaved() {
        if let saved = UserPrefsStore.shared.load() {
            homeAddress = saved.homeAddress
            workAddress = saved.workAddress
            selectedDays = Set(saved.days)
        }
    }

    private func daySort(_ a: String, _ b: String) -> Bool {
        let order = ["السبت","الأحد","الاثنين","الثلاثاء","الأربعاء","الخميس","الجمعة"]
        return (order.firstIndex(of: a) ?? 0) < (order.firstIndex(of: b) ?? 0)
    }
}

// MARK: - Components

/// حقل بعنوان وأيقونة — تصميم حديث
private struct LabeledField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String

    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .trailing)

            HStack(spacing: 10) {
                // الأيقونة على اليسار تناسب RTL
                Image(systemName: icon)
                    .foregroundColor(Theme.brandEnd)
                TextField(placeholder, text: $text)
                    .multilineTextAlignment(.trailing)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.tertiarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.black.opacity(0.06), lineWidth: 1)
            )
        }
    }
}

/// كبسولة يوم مع حالة مفعّلة/معطّلة
private struct DayPill: View {
    let title: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .frame(maxWidth: .infinity)
                .background(
                    Capsule().fill(isOn ? Theme.brandStart.opacity(0.18)
                                        : Color.gray.opacity(0.16))
                )
                .overlay(
                    Capsule().strokeBorder(
                        isOn ? Theme.brandEnd.opacity(0.55)
                             : Color.black.opacity(0.08), lineWidth: 1
                    )
                )
                .foregroundColor(isOn ? Theme.brandEnd : .primary)
        }
        .buttonStyle(.plain)
    }
}
