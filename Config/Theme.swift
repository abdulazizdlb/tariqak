import SwiftUI

enum Theme {
    // Primary Colors
    static let brandStart = Color(hex: "#4F46E5") // Indigo
    static let brandEnd = Color(hex: "#7C3AED")   // Purple
    static let success = Color(hex: "#10B981")    // Green
    static let warning = Color(hex: "#F59E0B")    // Amber
    static let error = Color(hex: "#EF4444")      // Red
    
    // Background Colors
    static let bg = Color(uiColor: .systemBackground)
    static let card = Color(uiColor: .secondarySystemBackground) // Changed from cardBg
    static let textPrimary = Color.primary
    static let textSubtle = Color.secondary
    
    // UI Constants
    static let corner: CGFloat = 12 // Keep this name
    
    // Gradients
    static var brandGradient: LinearGradient {
        LinearGradient(
            colors: [brandStart, brandEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// Color extension (same as before)
extension Color {
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:(a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r)/255, green: Double(g)/255, blue: Double(b)/255, opacity: Double(a)/255)
    }
}
