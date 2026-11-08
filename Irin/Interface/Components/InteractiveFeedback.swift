import SwiftUI

struct InteractiveFeedback: ViewModifier {
    let isPressed: Bool
    @State private var isHovered = false
    @Environment(\.isEnabled) private var isEnabled

    func body(content: Content) -> some View {
        content
            .brightness(showsHover ? Interaction.hoverBrightness : 0)
            .opacity(opacity)
            .pointerStyle(isEnabled ? .link : nil)
            .onHover { isHovered = $0 }
            .animation(Interaction.animation, value: isHovered)
            .animation(Interaction.animation, value: isPressed)
    }

    private var showsHover: Bool {
        isHovered && isEnabled && !isPressed
    }

    private var opacity: Double {
        guard isEnabled else { return Interaction.disabledOpacity }
        return isPressed ? Interaction.pressedOpacity : 1
    }
}

extension View {
    func interactiveFeedback(isPressed: Bool) -> some View {
        modifier(InteractiveFeedback(isPressed: isPressed))
    }
}
