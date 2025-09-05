import SwiftUI

struct HomeView: View {
    // متغيرات تمثل مدخلات المستخدم
    @State private var homeAddress: String = ""
    @State private var workAddress: String = ""
    @State private var selectedDays: Set<Int> = []  // نخزن الأيام كأرقام

    private let weekdayNames = ["السبت","الأحد","الاثنين","الثلاثاء","الأربعاء","الخميس","الجمعة"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .trailing, spacing: 20) {
                    Text("طريقك")
                        .font(.system(size: 34, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, 8)

                    // إدخال العناوين
                    VStack(alignment: .trailing, spacing: 12) {
                        Text("منزلي").font(.headline)
                        TextField("أدخل عنوان المنزل", text: $homeAddress)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .multilineTextAlignment(.trailing)

                        Text("عملي").font(.headline)
                        TextField("أدخل عنوان العمل", text: $workAddress)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .multilineTextAlignment(.trailing)
                    }

                    // اختيار الأيام
                    VStack(alignment: .trailing, spacing: 8) {
                        Text("أيام الذهاب").font(.headline)
                        HStack {
                            ForEach(Array(weekdayNames.enumerated()), id: \.offset) { idx, name in
                                Text(name)
                                    .font(.subheadline)
                                    .padding(.vertical, 8).padding(.horizontal, 12)
                                    .background(selectedDays.contains(idx) ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                    .clipShape(Capsule())
                                    .onTapGesture {
                                        if selectedDays.contains(idx) {
                                            selectedDays.remove(idx)
                                        } else {
                                            selectedDays.insert(idx)
                                        }
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                    // زر الحفظ
                    Button(action: savePrefs) {
                        Text("احسب الآن")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .navigationTitle("الرئيسية")
            .environment(\.layoutDirection, .rightToLeft)
        }
    }

    // حفظ البيانات
    private func savePrefs() {
        var prefs = UserPrefs()
        prefs.homeAddress = homeAddress
        prefs.workAddress = workAddress
        prefs.weekdays = Array(selectedDays)
        UserPrefsStore.shared.save(prefs)
        print("✅ Saved to UserDefaults: \(prefs)")
    }
}
