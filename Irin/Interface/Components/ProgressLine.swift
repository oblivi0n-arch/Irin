import SwiftUI

struct ProgressLine: View {
    let progress: Double

    var body: some View {
        Capsule()
            .fill(Palette.raised)
            .frame(height: Metrics.lineWeight)
            .overlay {
                Capsule()
                    .fill(Palette.ink)
                    .scaleEffect(x: progress, y: 1)
            }
            .animation(.linear(duration: 1), value: progress)
    }
}

#Preview {
    VStack(spacing: 24) {
        ProgressLine(progress: 1)
        ProgressLine(progress: 0.5)
        ProgressLine(progress: 0.1)
    }
    .padding()
    .frame(width: 400)
    .background(Palette.surface)
}
