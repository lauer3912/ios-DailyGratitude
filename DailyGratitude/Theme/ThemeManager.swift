import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
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

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }

    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
}

struct AppColors {
    static let primary = Color(hex: "A78BFA")
    static let secondary = Color(hex: "7C5CBF")
    static let accent = Color(hex: "F4A261")

    static let darkBackground = Color(hex: "0F0F23")
    static let darkSurface = Color(hex: "1C1C1E")
    static let darkTextPrimary = Color(hex: "FFFFFF")
    static let darkTextSecondary = Color(hex: "9B9BAD")

    static let lightBackground = Color(hex: "FAFAFA")
    static let lightSurface = Color(hex: "FFFFFF")
    static let lightTextPrimary = Color(hex: "1A1A2E")
    static let lightTextSecondary = Color(hex: "6B6B7B")
}
