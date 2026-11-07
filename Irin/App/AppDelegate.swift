import AppKit
import Observation

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private let session = AwakeSession()
    private lazy var panelController = PanelController(session: session)
    private var ticker: Timer?
    private let battery: any BatteryReading = SystemBattery()

    func applicationDidFinishLaunching(_ notification: Notification) {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        item.button?.target = self
        item.button?.action = #selector(togglePanel)
        statusItem = item
        Preferences.apply(to: session)
        
        observeSession()
        startTicker()
    }

    @objc private func togglePanel() {
        panelController.toggle(on: statusItem?.button?.window?.screen)
    }

    // MARK: - Session

    private func observeSession() {
        withObservationTracking {
            updateIcon(isWatching: session.isWatching)
        } onChange: { [weak self] in
            Task { @MainActor in
                self?.observeSession()
            }
        }
    }

    private func updateIcon(isWatching: Bool) {
        statusItem?.button?.image = NSImage(
            systemSymbolName: isWatching ? "eye" : "eye.half.closed",
            accessibilityDescription: IrinApp.appName
        )
    }

    private func startTicker() {
        ticker = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self else { return }
                self.session.expireIfNeeded()
                self.session.stopIfBatteryLow(self.battery.current())
            }
        }
    }
}
