import SwiftUI

struct HomeView: View {
    // MARK: - Inputs
    @State private var homeAddress: String = ""
    @State private var workAddress: String = ""
    @State private var selectedDays: Set<String> = []

    // Toast
    @State private var showSavedToast = false

    // 👇 Closure يُستدعى عند الضغط "احسب الآن"
    var onCalculate: ((Commute) -> Void)? = nil

    // Days (RTL ready)
    private let days = ["السبت","الأحد","الاثنين","الثلاثاء","الأربعاء","الخميس","الجمعة"]
    // شبكة متكيفة لأزرار الأيام
    private let grid = [GridItem(.adaptive(minimum: 84), spacing: 10, alignment: .trailing)]

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .trailing, spacing: 20) {

                    // Header
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("طريقك")
                                .font(.system(size: 28, weight: .bold))
                            Text("خطط وقت خروجك الذكي")
                                .foregroundColor(Theme.textSubtle)
                        }
                    }

                    // Card: Inputs
                    VStack(alignment: .trailing, spacing: 16) {
                        LabeledField(title: "منزلي",
                                     placeholder: "ادخل عنوان المنزل",
                                     text: $homeAddress,
                                     icon: "house.fill")

                        LabeledField(title: "عملي",
                                     placeholder: "ادخل عنوان العمل",
                                     text: $workAddress,
                                     icon: "briefcase.fill")

                        VStack(alignment: .trailing, spacing: 10) {
                            Text("أيام الذهاب")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                            LazyVGrid(columns: grid, alignment: .trailing, spacing: 10) {
                                ForEach(days, id: \.self) { day in
                                    DayPill(title: day,
                                            isOn: selectedDays.contains(day)) {
                                        toggleDay(day)
                                    }
                                }
                            }
                        }
                    }
                    .padding(16)
                    .background(Theme.card)
                    .cornerRadius(Theme.corner)
                    .shadow(color: .black.opacity(0.08),
                            radius: Theme.cardShadow, y: 4)

                    // Actions
                    VStack(spacing: 12) {
                        // حفظ
                        Button(action: saveInputs) {
                            HStack(spacing: 8) {
                                Image(systemName: "tray.and.arrow.down.fill")
                                Text("حفظ").fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundColor(.white)
                            .background(Theme.brandGradient)
                            .cornerRadius(14)
                            .shadow(color: Theme.brandEnd.opacity(0.25),
                                    radius: 12, y: 6)
                        }
                        .buttonStyle(.plain)

                        // احسب الآن → يبني Commute وينادي onCalculate
                        Button {
                            let commute = Commute(
                                homeAddress: homeAddress
                                    .trimmingCharacters(in: .whitespacesAndNewlines),
                                workAddress: workAddress
                                    .trimmingCharacters(in: .whitespacesAndNewlines),
                                days: Array(selectedDays)
                            )
                            onCalculate?(commute)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "sparkle.magnifyingglass")
                                Text("احسب الآن").fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundColor(Theme.brandEnd)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(.tertiarySystemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Theme.brandEnd.opacity(0.25), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }

            // Toast
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
        // RTL
        .environment(\.layoutDirection, .rightToLeft)
        .animation(.spring(response: 0.35, dampingFraction: 0.9),
                   value: showSavedToast)
        .onAppear(perform: loadSaved)
    }

    // MARK: - Actions
    private func toggleDay(_ day: String) {
        if selectedDays.contains(day) { selectedDays.remove(day) }
        else { selectedDays.insert(day) }
    }

    private func saveInputs() {
        UserPrefsStore.shared.save(
            homeAddress: homeAddress,
            workAddress: workAddress,
            days: Array(selectedDays).sorted(by: daySort)
        )

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
        (days.firstIndex(of: a) ?? 0) < (days.firstIndex(of: b) ?? 0)
    }
}

// MARK: - Components

/// حقل بعنوان + أيقونة (مودرن)
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

/// كبسولة لاختيار اليوم
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
                             : Color.black.opacity(0.08),
                        lineWidth: 1
                    )
                )
                .foregroundColor(isOn ? Theme.brandEnd : .primary)
        }
        .buttonStyle(.plain)
    }
}
