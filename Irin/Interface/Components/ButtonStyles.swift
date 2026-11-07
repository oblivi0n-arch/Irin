import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.primaryButton)
            .foregroundStyle(Palette.inkInverted)
            .padding(.horizontal, Metrics.Spacing.l)
            .frame(minHeight: Metrics.controlHeight)
            .background(Palette.ink, in: .rect(cornerRadius: Metrics.Radius.control))
            .opacity(isEnabled ? (configuration.isPressed ? 0.8 : 1) : 0.3)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

struct InscribedButtonStyle: ButtonStyle {
    let inscription: String
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: Metrics.Spacing.s) {
            Text(inscription)
                .font(Typography.inscription)
                .tracking(Typography.Tracking.inscription)
                .foregroundStyle(Palette.inkInscription)

            configuration.label
                .font(Typography.caption)
                .foregroundStyle(Palette.ink)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Metrics.Spacing.m)
        .contentShape(.rect)
        .opacity(isEnabled ? (configuration.isPressed ? 0.6 : 1) : 0.3)
    }
}

extension ButtonStyle where Self == InscribedButtonStyle {
    static func inscribed(_ inscription: String) -> InscribedButtonStyle {
        InscribedButtonStyle(inscription: inscription)
    }
}

#Preview {
    HStack {
        Spacer()
        Button("Stop watching") {}
            .buttonStyle(.primary)
        Button("Stop watching") {}
            .buttonStyle(.primary)
            .disabled(true)
    }
    .padding()
    .frame(width: 460)
    .background(Palette.surface)
}
