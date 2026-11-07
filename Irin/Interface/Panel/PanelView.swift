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
                .font(.system(size: 30, weight: .light))

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
            Text(session.isWatching ? "Watching" : "Resting")
                .font(Typography.sectionLabel)
                .tracking(Typography.Tracking.sectionLabel)
                .textCase(.uppercase)
                .foregroundStyle(Palette.inkSecondary)

            Text(timerText(at: now))
                .font(Typography.timer)
                .foregroundStyle(session.isWatching ? Palette.ink : Palette.inkInscription)

            Text(subline)
                .font(Typography.caption)
                .foregroundStyle(Palette.inkSecondary)

            ProgressLine(progress: session.progress(at: now) ?? (session.isWatching ? 1 : 0))
                .padding(.top, Metrics.Spacing.s)
        }
    }

    private var presets: some View {
        VStack(spacing: Metrics.Spacing.m) {
            Text("Watch for")
                .font(Typography.sectionLabel)
                .tracking(Typography.Tracking.sectionLabel)
                .textCase(.uppercase)
                .foregroundStyle(Palette.inkLabel)

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
                onModeChange: { isUntil in
                    customTime.select(isUntil ? .until : .duration)
                },
                onDecrease: { customTime.decrease() },
                onIncrease: { customTime.increase() },
                onStart: {
                    selectedPresetID = nil
                    session.start(condition: customTime.condition())
                }
            )
        }
    }
    
    private var preferences: some View {
        VStack(spacing: Metrics.Spacing.m) {
            HStack(spacing: 0) {
                Toggle("Display stays on", isOn: $keepsDisplayOn)
                    .toggleStyle(.inscribed("ΦΩΣ"))

                Rectangle()
                    .fill(Palette.divider)
                    .frame(width: Metrics.hairline)

                Toggle("Stop below \(AwakeSession.lowBatteryPercent)) % battery", isOn: $stopsOnLowBattery)
                    .toggleStyle(.inscribed("ΔΥΝΑΜΙΣ"))
            }
            .fixedSize(horizontal: false, vertical: true)

            Text("The system itself always stays awake while \(IrinApp.appName) is watching.")
                .font(Typography.caption)
                .foregroundStyle(Palette.inkInscription)
        }
    }

    private var footer: some View {
        HStack {
            Button("Quit \(IrinApp.appName)") {
                NSApp.terminate(nil)
            }
            .buttonStyle(.quiet)

            Spacer()

            Button("Stop watching") {
                session.stop()
            }
            .buttonStyle(.primary)
            .disabled(!session.isWatching)
        }
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
}

#Preview {
    PanelView(session: AwakeSession())
}
