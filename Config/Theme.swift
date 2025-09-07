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
    static let cardBg = Color(uiColor: .secondarySystemBackground)
    static let surfaceBg = Color(uiColor: .tertiarySystemBackground)
    
    // Text Colors
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textSubtle = Color(uiColor: .tertiaryLabel)
    
    // UI Constants
    static let cornerRadius: CGFloat = 12
    static let cardCornerRadius: CGFloat = 16
    static let shadowRadius: CGFloat = 8
    static let padding: CGFloat = 16
    
    // Gradients
    static var brandGradient: LinearGradient {
        LinearGradient(
            colors: [brandStart, brandEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var successGradient: LinearGradient {
        LinearGradient(
            colors: [success, success.opacity(0.8)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// Enhanced Color extension
extension Color {
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
