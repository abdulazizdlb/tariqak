import Foundation
import Combine

/// ViewModel أساسي لشاشة الرئيسية.
/// ملاحظة: هذا الإصدار مبسّط فقط لإرضاء الاستدعاءات من RootView/HomeView.
/// سنوسّعه لاحقًا حسب احتياج الواجهة.
final class HomeViewModel: ObservableObject {

    // MARK: - Dependencies
    let engine: PredictionEngine

    // MARK: - Input Model
    /// حالة التنقّل الحالية التي نمرّرها من RootView
    @Published var commute: Commute

    // MARK: - UI Bindings (مبدئية – نربطها لاحقًا داخل HomeView)
    @Published var fromText: String = ""
    @Published var toText: String = ""
    /// نافذة زمنية مبدئية للعرض فقط (نحدّثها لاحقًا)
    @Published var windowStart: Date = Date()
    @Published var windowEnd: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()

    /// أيام الأسبوع المختارة: 1 = الأحد ... 7 = السبت (قابلة للتغيير حسب ما اعتمدت)
    @Published var selectedDays: Set<Int> = []

    // MARK: - Output / State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // MARK: - Init
    init(engine: PredictionEngine, commute: Commute) {
        self.engine = engine
        self.commute = commute

        // تعبئة مبدئية لنصوص العناوين (اختياري)
        // عدّل حسب حقول Commute/Coordinate عندك
        self.fromText = ""
        self.toText = ""
    }

    // MARK: - Public helpers (نوسّعها لاحقًا)
    /// تحديث الـ commute من إدخالات المستخدم (نضبطها لاحقًا عندما نكمل HomeView)
    func updateCommuteIfNeeded() {
        // هنا لاحقًا نجمع الإدخالات ونبني Commute جديد
        // حالياً فارغة لتفادي أخطاء بناء
    }

    /// حفظ تفضيلات المستخدم (نضيف التخزين لاحقًا)
    func saveUserPrefs() {
        // نضيف تخزين UserDefaults / Keychain لاحقًا
    }
}
