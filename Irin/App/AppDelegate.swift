import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private let panelController = PanelController()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        item.button?.image = NSImage(
            systemSymbolName: "eye.half.closed",
            accessibilityDescription: IrinApp.appName
            )
        item.button?.target = self
        item.button?.action = #selector(togglePanel)
        statusItem = item
    }
    
    @objc private func togglePanel() {
        panelController.toggle(on: statusItem?.button?.window?.screen)
    }
}
