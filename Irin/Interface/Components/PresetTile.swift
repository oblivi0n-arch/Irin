import SwiftUI

struct PresetTile: View {
    let title: String
    let numeral: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Metrics.Spacing.s) {
                Text(numeral)
                    .font(Typography.inscription)
                    .tracking(Typography.Tracking.inscription)
                    .foregroundStyle(isSelected ? Palette.inkInvertedSecondary : Palette.inkInscription)
                
                Text(title)
                    .font(Typography.button)
            }
            .frame(maxWidth: .infinity, minHeight: Metrics.tileHeight)
            .foregroundStyle(isSelected ? Palette.inkInverted : Palette.ink)
            .background(isSelected ? Palette.ink : Palette.raised, in: .rect(cornerRadius: Metrics.Radius.control))
            .overlay {
                RoundedRectangle(cornerRadius: Metrics.Radius.control)
                    .strokeBorder(isSelected ? Palette.ink : Palette.stroke)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack {
        PresetTile(title: "1 hour", numeral: "Αʹ", isSelected: false) {}
        PresetTile(title: "2 hours", numeral: "Βʹ", isSelected: true) {}
    }
    .padding()
    .frame(width: 300)
    .background(Palette.surface)
}
