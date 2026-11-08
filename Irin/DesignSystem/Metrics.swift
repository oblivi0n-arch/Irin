import CoreGraphics

enum Metrics {
    enum Spacing {
        static let xs: CGFloat = 4
        static let s: CGFloat = 8
        static let m: CGFloat = 12
        static let l: CGFloat = 18
        static let xl: CGFloat = 28
    }

    enum Radius {
        static let control: CGFloat = 8
        static let panel: CGFloat = 14
    }

    static let controlHeight: CGFloat = 44
    static let panelWidth: CGFloat = 680
    static let tileHeight: CGFloat = 72
    static let customValueWidth: CGFloat = 96
    static let actionMinWidth: CGFloat = 140
    static let lineWeight: CGFloat = 2
    static let meanderHeight: CGFloat = 12
    static let toggleMarkWidth: CGFloat = 24
    static let hairline: CGFloat = 1
}
