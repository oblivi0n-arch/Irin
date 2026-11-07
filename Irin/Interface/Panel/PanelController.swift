import AppKit
import SwiftUI

final class PanelController: NSObject, NSWindowDelegate {
    private lazy var panel: NSPanel = makePanel()
    private let session: AwakeSession

    init(session: AwakeSession) {
        self.session = session
        super.init()
    }

    func toggle(on screen: NSScreen?) {
        panel.isVisible ? close() : open(on: screen)
    }

    func open(on screen: NSScreen?) {
        position(on: screen ?? NSScreen.main)
        panel.makeKeyAndOrderFront(nil)
    }

    func close() {
        panel.orderOut(nil)
    }

    func windowDidResignKey(_ notification: Notification) {
        close()
    }

    private func makePanel() -> NSPanel {
        let panel = KeyablePanel(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: true
        )
        panel.hidesOnDeactivate = false
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.level = .statusBar
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.delegate = self

        let hosting = NSHostingController(rootView: PanelView(session: session))
        panel.contentViewController = hosting
        return panel
    }

    private func position(on screen: NSScreen?) {
        guard let screen, let content = panel.contentViewController else { return }

        let size = content.view.fittingSize
        let menuBarHeight = screen.frame.maxY - screen.visibleFrame.maxY

        let origin = NSPoint(
            x: screen.frame.midX - size.width / 2,
            y: screen.frame.maxY - menuBarHeight - Metrics.Spacing.s - size.height
        )
        panel.setFrame(NSRect(origin: origin, size: size), display: true)
    }
}

final class KeyablePanel: NSPanel {
    override var canBecomeKey: Bool { true }

    override func cancelOperation(_ sender: Any?) {
        orderOut(nil)
    }
}
