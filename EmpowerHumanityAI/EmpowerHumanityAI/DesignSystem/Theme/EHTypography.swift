import SwiftUI

// MARK: - EHTypography
// Display/headings: Plus Jakarta Sans (bundled or SF Pro fallback)
// Interface/body: Inter (bundled or SF Pro fallback)
// Structure font usage so custom fonts can be added locally after Xcode open.

enum EHTypography {
    // MARK: - Font Names
    // When Plus Jakarta Sans and Inter are added to the project bundle,
    // update these constants and register the fonts in Info.plist.
    private static let displayFont = "PlusJakartaSans-Bold"
    private static let displayFontSemibold = "PlusJakartaSans-SemiBold"
    private static let displayFontMedium = "PlusJakartaSans-Medium"
    private static let bodyFont = "Inter-Regular"
    private static let bodyFontMedium = "Inter-Medium"
    private static let bodyFontSemibold = "Inter-SemiBold"

    private static func display(_ name: String, size: CGFloat) -> Font {
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size)
        }
        return .system(size: size, weight: .bold, design: .rounded)
    }

    private static func body(_ name: String, size: CGFloat, weight: Font.Weight = .regular) -> Font {
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size)
        }
        return .system(size: size, weight: weight)
    }

    // MARK: - Scale (all in pt, matching web px at 1:1 for reference)

    /// 44pt — hero moments, landing headline
    static var hero: Font { display(displayFont, size: 44) }

    /// 36pt — page titles (h1)
    static var h1: Font { display(displayFont, size: 36) }

    /// 30pt — section headings (h2)
    static var h2: Font { display(displayFontSemibold, size: 30) }

    /// 24pt — card headings (h3)
    static var h3: Font { display(displayFontSemibold, size: 24) }

    /// 20pt — subheadings (h4)
    static var h4: Font { display(displayFontMedium, size: 20) }

    /// 18pt — large body
    static var bodyLg: Font { body(bodyFont, size: 18) }

    /// 16pt — standard body
    static var bodyMd: Font { body(bodyFont, size: 16) }

    /// 14pt — small body
    static var bodySm: Font { body(bodyFont, size: 14) }

    /// 14pt medium — emphasized body
    static var bodySmMedium: Font { body(bodyFontMedium, size: 14, weight: .medium) }

    /// 13pt — labels, chips
    static var label: Font { body(bodyFontMedium, size: 13, weight: .medium) }

    /// 12pt — captions
    static var caption: Font { body(bodyFont, size: 12) }

    /// 11pt — micro labels
    static var micro: Font { body(bodyFont, size: 11) }

    // MARK: - Semantic Aliases

    static var sectionTitle: Font { h3 }
    static var cardTitle: Font { h4 }
    static var cardBody: Font { bodySm }
    static var navLabel: Font { bodySm }
    static var buttonLabel: Font { bodySmMedium }
    static var timestamp: Font { caption }
    static var badge: Font { micro }
}
