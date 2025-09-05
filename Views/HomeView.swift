import SwiftUI

struct HomeView: View {
    // مدخلات المستخدم
    @State private var homeAddress: String = ""
    @State private var workAddress: String = ""
    @State private var selectedDays: Set<String> = []

    // توست مصغّر بعد الحفظ
    @State private var showSavedToast = false

    // أيام الأسبوع بالعربي (يمشي RTL طبيعي)
    private let days = ["السبت", "الأحد", "الاثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة"]

    // شبكة مرنة لترتيب الأزرار (تلتف تلقائياً)
    private let grid = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)

    var body: some View {
        ScrollView {
            VStack(alignment: .trailing, spacing: 18) {
                // العنوان
                Text("الرئيسية")
                    .font(.title2).bold()
                    .frame(maxWidth: .infinity, alignment: .trailing)

                // منزل
                VStack(alignment: .trailing, spacing: 8) {
                    Text("منزلي")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    TextField("ادخل عنوان المنزل", text: $homeAddress)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .multilineTextAlignment(.trailing)
                }

                // عمل
                VStack(alignment: .trailing, spacing: 8) {
                    Text("عملي")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    TextField("ادخل عنوان العمل", text: $workAddress)
                        .textFieldStyle(.plain)
                        .padding(12)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .multilineTextAlignment(.trailing)
                }

                // أيام الذهاب
                VStack(alignment: .trailing, spacing: 10) {
                    Text("أيام الذهاب")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    LazyVGrid(columns: grid, alignment: .trailing, spacing: 10) {
                        ForEach(days, id: \.self) { day in
                            Button {
                                toggleDay(day)
                            } label: {
                                Text(day)
                                    .font(.system(size: 14, weight: .medium))
                                    .lineLimit(1)                // يمنع تفكيك الحروف عموديًا
                                    .minimumScaleFactor(0.8)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        Capsule()
                                            .fill(selectedDays.contains(day)
                                                  ? Color.blue.opacity(0.20)
                                                  : Color.gray.opacity(0.20))
                                    )
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // زر الحفظ
                Button {
                    saveInputs()
                } label: {
                    Text("حفظ")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .font(.headline)
                }
                .padding(.top, 6)
            }
            .padding(20)
        }
        // 👈 انتبه: فرض اتجاه RTL على كامل الصفحة
        .environment(\.layoutDirection, .rightToLeft)
        .overlay(alignment: .bottom) {
            if showSavedToast {
                Label("تم حفظ بياناتك ✅", systemImage: "checkmark.seal.fill")
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.35), value: showSavedToast)
        .onAppear(perform: loadSaved)
    }

    // MARK: - Actions

    private func toggleDay(_ day: String) {
        if selectedDays.contains(day) {
            selectedDays.remove(day)
        } else {
            selectedDays.insert(day)
        }
    }

    private func saveInputs() {
        // خزّن المدخلات (عدّل التوقيع لو مخزنّك مختلف)
        UserPrefsStore.shared.save(
            homeAddress: homeAddress,
            workAddress: workAddress,
            days: Array(selectedDays).sorted(by: daySort)
        )

        showSavedToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            showSavedToast = false
        }
    }

    private func loadSaved() {
        // حمّل القيم المحفوظة إن وُجدت
        if let saved = UserPrefsStore.shared.load() {
            homeAddress = saved.homeAddress
            workAddress = saved.workAddress
            selectedDays = Set(saved.days)
        }
    }

    // ترتيب الأيام بنفس مصفوفة days
    private func daySort(_ a: String, _ b: String) -> Bool {
        (days.firstIndex(of: a) ?? 0) < (days.firstIndex(of: b) ?? 0)
    }
}
