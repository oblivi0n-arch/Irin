import Foundation

enum Preferences {
    static let keepsDisplayOn = "keepsDisplayOn"
    static let stopsOnLowBattery = "stopsOnLowBattery"

    static func apply(to session: AwakeSession, defaults: UserDefaults = .standard) {
        session.keepsDisplayOn = defaults.bool(forKey: keepsDisplayOn)
        session.stopsOnLowBattery = defaults.bool(forKey: stopsOnLowBattery)
    }
}
