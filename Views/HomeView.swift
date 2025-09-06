import SwiftUI

struct HomeView: View {
    // القيم اللي عندك للحقل… (home, work, times, days ...)
    // …
    let onCalculate: (Commute) -> Void

    var body: some View {
        Form {
            // الحقول...
            // …

            Section {
                Button("احسب الآن") {
                    let commute = Commute(
                        homeAddress: homeAddress,
                        workAddress: workAddress,
                        days: selectedDays,
                        windowStart: windowStart,
                        windowEnd: windowEnd
                    )
                    // (اختياري) حفظ محلي
                    // try? UserPrefsStore.shared.save(commute)

                    onCalculate(commute) // ← التنقل يصير من RootView
                }
            }
        }
        .navigationTitle("الرئيسية")
        .environment(\.layoutDirection, .rightToLeft)
    }
}
