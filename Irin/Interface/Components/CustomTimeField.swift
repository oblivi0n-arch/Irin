import SwiftUI

struct CustomTimeField: View {
    let isUntil: Bool
    let value: String
    let onModeChange: (Bool) -> Void
    let onDecrease: () -> Void
    let onIncrease: () -> Void
    let actionTitle: String
    let actionIsOutlined: Bool
    let onAction: () -> Void

    var body: some View {
        HStack(spacing: Metrics.Spacing.m) {
            modeButton("For", isSelected: !isUntil) { onModeChange(false) }
            modeButton("Until", isSelected: isUntil) { onModeChange(true) }

            Spacer()

            stepButton("minus", label: "Less", action: onDecrease)
            Text(value)
                .font(Typography.body)
                .monospacedDigit()
                .frame(minWidth: Metrics.customValueWidth)
            stepButton("plus", label: "More", action: onIncrease)

            Spacer()

            Button(actionTitle, action: onAction)
                .buttonStyle(PrimaryButtonStyle(isOutlined: actionIsOutlined))
        }
        .padding(.vertical, Metrics.Spacing.s)
        .padding(.leading, Metrics.Spacing.l)
        .padding(.trailing, Metrics.Spacing.s)
        .background(Palette.raised, in: .rect(cornerRadius: Metrics.Radius.control))
        .overlay {
            RoundedRectangle(cornerRadius: Metrics.Radius.control)
                .strokeBorder(Palette.stroke)
        }
    }

    private func modeButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(title, action: action)
            .buttonStyle(.interactive)
            .font(Typography.button)
            .foregroundStyle(isSelected ? Palette.ink : Palette.inkInscription)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private func stepButton(_ symbol: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .frame(width: Metrics.controlHeight, height: Metrics.controlHeight)
                .contentShape(.rect)
        }
        .buttonStyle(.interactive)
        .font(Typography.body)
        .foregroundStyle(Palette.inkSecondary)
        .accessibilityLabel(label)
    }
}

#Preview {
    VStack {
        CustomTimeField(isUntil: false, value: "1 h 30 min",
                        onModeChange: { _ in }, onDecrease: {}, onIncrease: {},
                        actionTitle: "Start", actionIsOutlined: false, onAction: {})
        CustomTimeField(isUntil: true, value: "17:45",
                        onModeChange: { _ in }, onDecrease: {}, onIncrease: {},
                        actionTitle: "Stop watching", actionIsOutlined: true, onAction: {})
    }
    .padding()
    .frame(width: 624)
    .background(Palette.surface)
}
