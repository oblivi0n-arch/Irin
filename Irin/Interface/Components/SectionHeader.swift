import SwiftUI

struct SectionHeader: View {
    let title: String
    let inscription: String

    var body: some View {
        HStack(spacing: Metrics.Spacing.m) {
            rule

            HStack(alignment: .firstTextBaseline, spacing: Metrics.Spacing.s) {
                Text(title)
                    .font(Typography.sectionLabel)
                    .tracking(Typography.Tracking.sectionLabel)
                    .textCase(.uppercase)
                    .foregroundStyle(Palette.inkLabel)

                Text("·")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Palette.inkInscription)

                Text(inscription)
                    .font(Typography.inscription)
                    .tracking(Typography.Tracking.inscription)
                    .foregroundStyle(Palette.inkInscription)
            }
            .fixedSize()

            rule
        }
    }

    private var rule: some View {
        Rectangle()
            .fill(Palette.divider)
            .frame(height: Metrics.hairline)
    }
}

#Preview {
    SectionHeader(title: "Watch for", inscription: "ΧΡΟΝΟΣ")
        .padding()
        .frame(width: 624)
        .background(Palette.surface)
}
