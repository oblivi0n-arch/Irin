import AppKit
import SwiftUI

struct PanelView: View {
    let session: AwakeSession
    @State private var selectedPresetID: Preset.ID?
    @State private var customTime = CustomTime()
    
    @AppStorage(Preferences.keepsDisplayOn) private var keepsDisplayOn = false
    @AppStorage(Preferences.stopsOnLowBattery) private var stopsOnLowBattery = false

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            VStack(spacing: Metrics.Spacing.xl) {
                header
                status(at: context.date)
                presets
                preferences
                footer
            }
        }
        .foregroundStyle(Palette.ink)
        .padding(Metrics.Spacing.xl)
        .frame(width: Metrics.panelWidth)
        .background(Palette.surface, in: .rect(cornerRadius: Metrics.Radius.panel))
        .overlay {
            RoundedRectangle(cornerRadius: Metrics.Radius.panel)
                .strokeBorder(Palette.stroke)
        }
        .onChange(of: keepsDisplayOn) { session.keepsDisplayOn = keepsDisplayOn }
        .onChange(of: stopsOnLowBattery) { session.stopsOnLowBattery = stopsOnLowBattery }
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: Metrics.Spacing.s) {
            Image(systemName: session.isWatching ? "eye" : "eye.half.closed")
                .font(Typography.eye)

            Text(IrinApp.appName.uppercased())
                .font(Typography.wordmark)
                .tracking(Typography.Tracking.wordmark)

            Text(IrinApp.epithet)
                .font(Typography.inscription)
                .tracking(Typography.Tracking.inscription)
                .foregroundStyle(Palette.inkInscription)
        }
    }

    private func status(at now: Date) -> some View {
        VStack(spacing: Metrics.Spacing.s) {
            HStack(alignment: .firstTextBaseline, spacing: Metrics.Spacing.s) {
                Text(session.isWatching ? "Watching" : "Resting")
                    .font(Typography.sectionLabel)
                    .tracking(Typography.Tracking.sectionLabel)
                    .textCase(.uppercase)
                    .foregroundStyle(Palette.inkSecondary)

                Text("·")
                    .font(Typography.sectionLabel)
                    .foregroundStyle(Palette.inkInscription)

                Text(session.isWatching ? Inscription.watching : Inscription.resting)
                    .font(Typography.inscription)
                    .tracking(Typography.Tracking.inscription)
                    .foregroundStyle(Palette.inkInscription)
            }

            Text(timerText(at: now))
                .font(Typography.timer)
                .foregroundStyle(session.isWatching ? Palette.ink : Palette.inkInscription)

            Text(subline)
                .font(Typography.caption)
                .foregroundStyle(Palette.inkSecondary)

            meander
                .padding(.top, Metrics.Spacing.s)

            ProgressLine(progress: session.progress(at: now) ?? (session.isWatching ? 1 : 0))
        }
    }

    private var presets: some View {
        VStack(spacing: Metrics.Spacing.m) {
            SectionHeader(title: "Watch for", inscription: Inscription.watchFor)

            HStack(spacing: Metrics.Spacing.s) {
                ForEach(Preset.all) { preset in
                    PresetTile(
                        title: preset.title,
                        numeral: preset.numeral,
                        isSelected: session.isWatching && selectedPresetID == preset.id
                    ) {
                        selectedPresetID = preset.id
                        session.start(condition: preset.condition)
                    }
                }
            }
            
            CustomTimeField(
                isUntil: customTime.mode == .until,
                value: customValueText,
                stepMinutes: CustomTime.step,
                onModeChange: { isUntil in
                    customTime.select(isUntil ? .until : .duration)
                },
                onDecrease: { customTime.decrease() },
                onIncrease: { customTime.increase() },
                actionTitle: session.isWatching ? "Stop watching" : "Start",
                actionIsOutlined: session.isWatching,
                onAction: customAction
            )
        }
    }
    
    private var preferences: some View {
        VStack(spacing: Metrics.Spacing.m) {
            HStack(spacing: 0) {
                Toggle("Display stays on", isOn: $keepsDisplayOn)
                    .toggleStyle(.inscribed(Inscription.display))

                Rectangle()
                    .fill(Palette.divider)
                    .frame(width: Metrics.hairline)

                Toggle("Stop below \(AwakeSession.lowBatteryPercent) % battery", isOn: $stopsOnLowBattery)
                    .toggleStyle(.inscribed(Inscription.battery))
            }
            .fixedSize(horizontal: false, vertical: true)

            Text("The system itself always stays awake while \(IrinApp.appName) is watching.")
                .font(Typography.caption)
                .foregroundStyle(Palette.inkInscription)
        }
    }

    private var footer: some View {
        VStack(spacing: Metrics.Spacing.m) {
            meander

            HStack(alignment: .firstTextBaseline) {
                signature
                Spacer()
                Button("Quit \(IrinApp.appName)") {
                    NSApp.terminate(nil)
                }
                .buttonStyle(.inscribed(Inscription.quit))
            }
        }
    }
    
    private var signature: some View {
        Text(IrinApp.signature)
            .font(Typography.inscription)
            .tracking(Typography.Tracking.inscription)
            .foregroundStyle(Palette.inkInscription)
    }
    
    private var meander: some View {
        Meander()
            .stroke(Palette.ornament, lineWidth: Metrics.hairline)
            .frame(height: Metrics.meanderHeight)
    }

    // MARK: - Text

    private func timerText(at now: Date) -> String {
        if let remaining = session.remaining(at: now) {
            return DurationText.clock(remaining)
        }
        return session.isWatching ? "∞" : "—"
    }

    private var subline: String {
        guard session.isWatching else {
            return session.stoppedOnLowBattery
                ? "Stopped: battery below \(AwakeSession.lowBatteryPercent) %."
                : "Your Mac may sleep as usual."
        }
        guard let endsAt = session.endsAt else {
            return "Your Mac stays awake until you stop it."
        }
        return "Your Mac stays awake until \(endsAt.formatted(date: .omitted, time: .shortened))."
    }
    
    private var customValueText: String {
        switch customTime.mode {
        case .duration: DurationText.short(minutes: customTime.durationMinutes)
        case .until: DurationText.timeOfDay(minutes: customTime.untilMinutes)
        }
    }
    
    private func customAction() {
        if session.isWatching {
            session.stop()
        } else {
            selectedPresetID = nil
            session.start(condition: customTime.condition())
        }
    }
}

#Preview {
    PanelView(session: AwakeSession())
}
