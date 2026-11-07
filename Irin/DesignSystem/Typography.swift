import SwiftUI

enum Typography {
    static let wordmark = Font.system(size: 30, weight: .semibold, design: .serif)
    static let timer = Font.system(size: 64, weight: .medium, design: .serif).monospacedDigit()
    static let inscription = Font.system(size: 11, weight: .regular, design: .serif)

    static let sectionLabel = Font.system(size: 11, weight: .medium)
    static let body = Font.system(size: 14, weight: .medium)
    static let caption = Font.system(size: 12)
    static let button = Font.system(size: 13, weight: .semibold)
    static let primaryButton = Font.system(size: 14, weight: .semibold)

    enum Tracking {
        static let wordmark: CGFloat = 12.6
        static let inscription: CGFloat = 3.3
        static let sectionLabel: CGFloat = 1.8
    }
}
