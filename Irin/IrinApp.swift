import SwiftUI

@main
struct IrinApp: App {
    var body: some Scene {
        MenuBarExtra(IrinApp.appName, systemImage: "eye.half.closed") {
            Text("\(IrinApp.appName) is resting.")
                .padding()
        }
        .menuBarExtraStyle(.window)
    }
}
