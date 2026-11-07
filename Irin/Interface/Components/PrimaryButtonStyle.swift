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

struct QuietButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.caption)
            .foregroundStyle(configuration.isPressed ? Palette.ink : Palette.inkSecondary)
            .frame(minHeight: Metrics.controlHeight)
            .contentShape(.rect)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

extension ButtonStyle where Self == QuietButtonStyle {
    static var quiet: QuietButtonStyle { QuietButtonStyle() }
}

#Preview {
    HStack {
        Button("Quit") {}
            .buttonStyle(.quiet)
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
