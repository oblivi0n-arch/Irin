import SwiftUI

@main
struct IrinApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
