import SwiftUI

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        let r = Double((hex >> 16) & 0xFF) / 255
        let g = Double((hex >> 8) & 0xFF) / 255
        let b = Double(hex & 0xFF) / 255
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }

    /// A color that switches between a light and dark value with the system appearance,
    /// independent of any asset catalog.
    static func dynamic(light: Color, dark: Color) -> Color {
        Color(UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }
}

/// Design tokens carried over from the web prototype: an ink-on-paper, diary/ledger
/// palette for the app itself, with one restrained accent used for the "disconnected"
/// hero number and the bold, Strava-style share card.
enum Theme {
    static let paper = Color.dynamic(light: Color(hex: 0xE9E4D3), dark: Color(hex: 0x16130E))
    static let page = Color.dynamic(light: Color(hex: 0xF2EEE0), dark: Color(hex: 0x1C1811))
    static let panel = Color.dynamic(light: Color(hex: 0xECE7D6), dark: Color(hex: 0x221D15))

    static let ink = Color.dynamic(light: Color(hex: 0x221D15), dark: Color(hex: 0xE9E1CC))
    static let ink2 = Color.dynamic(light: Color(hex: 0x5B5546), dark: Color(hex: 0xB7AD91))
    static let ink3 = Color.dynamic(light: Color(hex: 0x8C8571), dark: Color(hex: 0x83795F))

    static let rule = Color.dynamic(light: Color(hex: 0x221D15, alpha: 0.24), dark: Color(hex: 0xE9E1CC, alpha: 0.22))
    static let ruleSoft = Color.dynamic(light: Color(hex: 0x221D15, alpha: 0.13), dark: Color(hex: 0xE9E1CC, alpha: 0.12))

    static let accent = Color.dynamic(light: Color(hex: 0xA23E2E), dark: Color(hex: 0xC4634B))
    static let accentSoft = Color.dynamic(light: Color(hex: 0xA23E2E, alpha: 0.09), dark: Color(hex: 0xC4634B, alpha: 0.14))

    /// Reversed cream ink used for text sitting on top of the solid accent (bold recap card).
    static let cream = Color(hex: 0xF7EFE4)

    static func serif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func mono(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }

    /// The bold, Strava-metric-tile numeral face — default SF Pro, heavy weight.
    static func grotesk(_ size: CGFloat, weight: Font.Weight = .heavy) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
}
