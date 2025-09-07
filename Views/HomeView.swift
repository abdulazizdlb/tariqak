import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: - Dependencies
    let engine: PredictionEngine
    
    // MARK: - Published Properties
    @Published var commute: Commute
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showToast = false
    @Published var toastMessage = ""
    
    // MARK: - Input Properties
    @Published var fromText = "" {
        didSet { commute.homeAddress = fromText }
    }
    
    @Published var toText = "" {
        didSet { commute.workAddress = toText }
    }
    
    @Published var selectedDays: Set<Int> = [] {
        didSet { commute.selectedDays = selectedDays }
    }
    
    @Published var windowStart = Date() {
        didSet { commute.windowStart = windowStart }
    }
    
    @Published var windowEnd = Date() {
        didSet { commute.windowEnd = windowEnd }
    }
    
    // MARK: - Computed Properties
    var isFormValid: Bool {
        !fromText.trimmingCharacters(in: .whitespaces).isEmpty &&
        !toText.trimmingCharacters(in: .whitespaces).isEmpty &&
        !selectedDays.isEmpty
    }
    
    // MARK: - Initialization
    init(engine: PredictionEngine, commute: Commute = Commute()) {
        self.engine = engine
        self.commute = commute
        
        loadSavedPreferences()
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        fromText = commute.homeAddress
        toText = commute.workAddress
        selectedDays = commute.selectedDays
        windowStart = commute.windowStart
        windowEnd = commute.windowEnd
    }
    
    private func loadSavedPreferences() {
        let prefs = UserPrefsStore.shared.load()
        fromText = prefs.homeAddress
        toText = prefs.workAddress
        if !prefs.weekdays.isEmpty {
            selectedDays = Set(prefs.weekdays)
        }
    }
    
    // MARK: - Public Methods
    func updateCommuteIfNeeded() {
        commute.homeAddress = fromText.trimmingCharacters(in: .whitespaces)
        commute.workAddress = toText.trimmingCharacters(in: .whitespaces)
        commute.selectedDays = selectedDays
        commute.windowStart = windowStart
        commute.windowEnd = windowEnd
    }
    
    func saveUserPrefs() {
        let prefs = UserPrefs(
            homeAddress: fromText.trimmingCharacters(in: .whitespaces),
            workAddress: toText.trimmingCharacters(in: .whitespaces),
            weekdays: Array(selectedDays)
        )
        
        UserPrefsStore.shared.save(prefs)
        toastMessage = "تم حفظ التفضيلات بنجاح"
        showToast = true
    }
}
