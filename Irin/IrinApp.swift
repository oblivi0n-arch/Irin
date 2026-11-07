import SwiftUI

@main
struct IrinApp: App {
    var body: some Scene {
        MenuBarExtra("Irin", systemImage: "eye.half.closed") {
            Text("Irin is resting.")
                .padding()
        }
        .menuBarExtraStyle(.window)
    }
}
