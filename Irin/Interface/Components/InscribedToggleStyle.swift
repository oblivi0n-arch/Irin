import SwiftUI

struct InscribedToggleStyle: ToggleStyle {
    let inscription: String

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            VStack(spacing: Metrics.Spacing.s) {
                Text(inscription)
                    .font(Typography.inscription)
                    .tracking(Typography.Tracking.inscription)
                    .foregroundStyle(configuration.isOn ? Palette.ink : Palette.inkInscription)

                configuration.label
                    .font(Typography.caption)
                    .foregroundStyle(configuration.isOn ? Palette.ink : Palette.inkSecondary)

                Rectangle()
                    .fill(configuration.isOn ? Palette.ink : Palette.stroke)
                    .frame(width: Metrics.toggleMarkWidth, height: Metrics.lineWeight)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Metrics.Spacing.m)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isToggle)
        .animation(.easeOut(duration: 0.2), value: configuration.isOn)
    }
}

extension ToggleStyle where Self == InscribedToggleStyle {
    static func inscribed(_ inscription: String) -> InscribedToggleStyle {
        InscribedToggleStyle(inscription: inscription)
    }
}

#Preview {
    @Previewable @State var display = true
    @Previewable @State var battery = false

    HStack(spacing: 0) {
        Toggle("Display stays on", isOn: $display).toggleStyle(.inscribed("ΦΩΣ"))
        Divider().frame(height: 48)
        Toggle("Stop below 20 % battery", isOn: $battery).toggleStyle(.inscribed("ΔΥΝΑΜΙΣ"))
    }
    .padding()
    .frame(width: 624)
    .background(Palette.surface)
}
