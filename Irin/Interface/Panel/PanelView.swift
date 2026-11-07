import SwiftUI

struct PanelView: View {
    var body: some View {
        VStack(spacing: Metrics.Spacing.s) {
            Image(systemName: "eye.half.closed")
                .font(.system(size: 30, weight: .light))

            Text(IrinApp.appName.uppercased())
                .font(Typography.wordmark)
                .tracking(Typography.Tracking.wordmark)

            Text(IrinApp.epithet)
                .font(Typography.inscription)
                .tracking(Typography.Tracking.inscription)
                .foregroundStyle(Palette.inkInscription)
        }
        .foregroundStyle(Palette.ink)
        .padding(Metrics.Spacing.xl)
        .frame(width: Metrics.panelWidth)
        .background(Palette.surface, in: .rect(cornerRadius: Metrics.Radius.panel))
        .overlay {
            RoundedRectangle(cornerRadius: Metrics.Radius.panel)
                .strokeBorder(Palette.stroke)
        }
    }
}

#Preview {
    PanelView()
}
