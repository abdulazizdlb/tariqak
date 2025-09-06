import SwiftUI

struct RootView: View {
    private let engine = PredictionEngine(provider: HereTrafficProvider())

    // 👇 حالة تخزن الـ commute اللي اختاره المستخدم
    @State private var navCommute: Commute? = nil

    var body: some View {
        NavigationStack {
            HomeView(onCalculate: { commute in
                // نخزن commute → التغيير يفتح شاشة النتيجة
                navCommute = commute
            })
            .navigationTitle("الرئيسية")
            // 👇 هنا الوجهة لما navCommute يصير فيه قيمة
            .navigationDestination(item: $navCommute) { commute in
                ResultView(engine: engine, commute: commute)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
