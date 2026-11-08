import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var isOutlined = false
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.primaryButton)
            .foregroundStyle(isOutlined ? Palette.ink : Palette.inkInverted)
            .padding(.horizontal, Metrics.Spacing.l)
            .frame(minWidth: Metrics.actionMinWidth, minHeight: Metrics.controlHeight)
            .background(isOutlined ? .clear : Palette.ink,
                        in: .rect(cornerRadius: Metrics.Radius.control))
            .overlay {
                if isOutlined {
                    RoundedRectangle(cornerRadius: Metrics.Radius.control)
                        .strokeBorder(Palette.ink, lineWidth: Metrics.lineWeight)
                }
            }
            .opacity(isEnabled ? (configuration.isPressed ? 0.8 : 1) : 0.3)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
    static var primaryOutlined: PrimaryButtonStyle { PrimaryButtonStyle(isOutlined: true) }
}

struct InscribedButtonStyle: ButtonStyle {
    let inscription: String
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: Metrics.Spacing.s) {
            Text(inscription)
                .font(Typography.inscription)
                .tracking(Typography.Tracking.inscription)
                .foregroundStyle(Palette.inkInscription)

            configuration.label
                .font(Typography.caption)
                .foregroundStyle(Palette.ink)
        }
        .padding(.vertical, Metrics.Spacing.s)
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
