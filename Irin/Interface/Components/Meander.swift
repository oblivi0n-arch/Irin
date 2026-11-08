import SwiftUI

/// A Greek key band, as painted around the necks of vases.
/// One tile is twice as wide as it is tall; whole tiles only, centred.
struct Meander: Shape {
    func path(in rect: CGRect) -> Path {
        let unit = rect.height / 12
        let tileWidth = 24 * unit
        let count = Int(rect.width / tileWidth)
        let inset = (rect.width - CGFloat(count) * tileWidth) / 2

        var path = Path()
        for index in 0..<count {
            let x = rect.minX + inset + CGFloat(index) * tileWidth
            func point(_ u: CGFloat, _ v: CGFloat) -> CGPoint {
                CGPoint(x: x + u * unit, y: rect.minY + v * unit)
            }
            path.move(to: point(0, 11.5))
            let corners: [(CGFloat, CGFloat)] = [(6, 11.5), (6, 1.5), (18, 1.5), (18, 8.5), (11, 8.5), (11, 5), (14, 5)]
            for (u, v) in corners {
                path.addLine(to: point(u, v))
            }
            path.move(to: point(18, 11.5))
            path.addLine(to: point(24, 11.5))
        }
        return path
    }
}

#Preview {
    Meander()
        .stroke(Palette.ornament, lineWidth: Metrics.hairline)
        .frame(height: Metrics.meanderHeight)
        .padding()
        .frame(width: 624)
        .background(Palette.surface)
}
