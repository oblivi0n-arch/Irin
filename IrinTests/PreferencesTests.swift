import Foundation
import Testing
@testable import Irin

@MainActor
@Suite(.serialized)
struct PreferencesTests {
    let defaults: UserDefaults = {
        let defaults = UserDefaults(suiteName: "PreferencesTests")!
        defaults.removePersistentDomain(forName: "PreferencesTests")
        return defaults
    }()

    @Test func applyReadsTheStoredChoices() {
        defaults.set(true, forKey: Preferences.keepsDisplayOn)
        defaults.set(true, forKey: Preferences.stopsOnLowBattery)
        let session = AwakeSession(power: FakePower())

        Preferences.apply(to: session, defaults: defaults)

        #expect(session.keepsDisplayOn)
        #expect(session.stopsOnLowBattery)
    }

    @Test func applyDefaultsToOffWhenNothingIsStored() {
        let session = AwakeSession(power: FakePower())

        Preferences.apply(to: session, defaults: defaults)

        #expect(session.keepsDisplayOn == false)
        #expect(session.stopsOnLowBattery == false)
    }
}
