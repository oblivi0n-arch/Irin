import Foundation
import Testing
@testable import Irin

final class FakePower: KeepAwake {
    private(set) var isActive = false
    private(set) var lastKind: PowerAssertion.Kind?

    func activate(_ kind: PowerAssertion.Kind, reason: String) {
        isActive = true
        lastKind = kind
    }

    func release() {
        isActive = false
    }
}

@MainActor
struct AwakeSessionTests {
    let power = FakePower()
    let start = Date(timeIntervalSinceReferenceDate: 0)

    @Test func startsResting() {
        let session = AwakeSession(power: power)

        #expect(session.isWatching == false)
        #expect(power.isActive == false)
    }

    @Test func startingHoldsTheAssertion() {
        let session = AwakeSession(power: power)
        session.start(condition: .duration(60), now: start)

        #expect(session.isWatching)
        #expect(power.isActive)
        #expect(power.lastKind == .system)
    }

    @Test func remainingCountsDown() {
        let session = AwakeSession(power: power)
        session.start(condition: .duration(60), now: start)

        #expect(session.remaining(at: start.addingTimeInterval(20)) == 40)
    }

    @Test func progressIsHalfAtHalfTime() {
        let session = AwakeSession(power: power)
        session.start(condition: .duration(60), now: start)

        #expect(session.progress(at: start.addingTimeInterval(30)) == 0.5)
    }

    @Test func expiresExactlyAtTheEnd() {
        let session = AwakeSession(power: power)
        session.start(condition: .duration(60), now: start)

        session.expireIfNeeded(at: start.addingTimeInterval(59))
        #expect(session.isWatching)

        session.expireIfNeeded(at: start.addingTimeInterval(60))
        #expect(session.isWatching == false)
        #expect(power.isActive == false)
    }

    @Test func indefinitelyNeverExpires() {
        let session = AwakeSession(power: power)
        session.start(condition: .indefinitely, now: start)

        session.expireIfNeeded(at: start.addingTimeInterval(365 * 24 * 3600))

        #expect(session.isWatching)
        #expect(session.remaining() == nil)
    }

    @Test func stopReleasesTheAssertion() {
        let session = AwakeSession(power: power)
        session.start(condition: .duration(60), now: start)
        session.stop()

        #expect(session.isWatching == false)
        #expect(power.isActive == false)
    }
    
    @Test func untilEndsAtTheGivenDate() {
        let session = AwakeSession(power: power)
        let end = start.addingTimeInterval(90 * 60)
        session.start(condition: .until(end), now: start)

        #expect(session.endsAt == end)
        #expect(session.remaining(at: start) == TimeInterval(90 * 60))
    }

    @Test func untilInThePastDoesNotStart() {
        let session = AwakeSession(power: power)
        session.start(condition: .until(start.addingTimeInterval(-60)), now: start)

        #expect(session.isWatching == false)
        #expect(power.isActive == false)
    }
    
    @Test func displayPreferenceChoosesTheAssertion() {
        let session = AwakeSession(power: power)
        session.keepsDisplayOn = true
        session.start(condition: .duration(60), now: start)

        #expect(power.lastKind == .display)
    }

    @Test func switchingDisplayWhileWatchingSwapsTheAssertion() {
        let session = AwakeSession(power: power)
        session.start(condition: .duration(60), now: start)
        session.keepsDisplayOn = true

        #expect(power.lastKind == .display)
        #expect(power.isActive)
    }

    @Test func switchingDisplayWhileRestingHoldsNothing() {
        let session = AwakeSession(power: power)
        session.keepsDisplayOn = true

        #expect(power.isActive == false)
    }
    
    @Test func lowBatteryStopsWatching() {
        let session = AwakeSession(power: power)
        session.stopsOnLowBattery = true
        session.start(condition: .indefinitely, now: start)
        session.stopIfBatteryLow(BatteryState(level: 0.19, isOnBattery: true))

        #expect(session.isWatching == false)
        #expect(power.isActive == false)
        #expect(session.stoppedOnLowBattery)
    }

    @Test func lowBatteryWhileChargingKeepsWatching() {
        let session = AwakeSession(power: power)
        session.stopsOnLowBattery = true
        session.start(condition: .indefinitely, now: start)
        session.stopIfBatteryLow(BatteryState(level: 0.05, isOnBattery: false))

        #expect(session.isWatching)
    }

    @Test func lowBatteryIsIgnoredWhenTheGuardIsOff() {
        let session = AwakeSession(power: power)
        session.start(condition: .indefinitely, now: start)
        session.stopIfBatteryLow(BatteryState(level: 0.19, isOnBattery: true))

        #expect(session.isWatching)
    }
    
    @Test func startingAgainClearsTheLowBatteryNote() {
        let session = AwakeSession(power: power)
        session.stopsOnLowBattery = true
        session.start(condition: .indefinitely, now: start)
        session.stopIfBatteryLow(BatteryState(level: 0.1, isOnBattery: true))
        session.start(condition: .duration(60), now: start)

        #expect(session.stoppedOnLowBattery == false)
    }
    
    @Test func startingAgainReplacesTheSession() {
        let session = AwakeSession(power: power)
        session.start(condition: .duration(60), now: start)
        session.start(condition: .duration(3600), now: start.addingTimeInterval(10))

        #expect(session.isWatching)
        #expect(power.isActive)
        #expect(session.endsAt == start.addingTimeInterval(3610))
    }

    @Test func batteryAtTheThresholdKeepsWatching() {
        let session = AwakeSession(power: power)
        session.stopsOnLowBattery = true
        session.start(condition: .indefinitely, now: start)
        session.stopIfBatteryLow(BatteryState(level: AwakeSession.lowBatteryLevel, isOnBattery: true))

        #expect(session.isWatching)
    }

    @Test func progressIsFullAtTheStart() {
        let session = AwakeSession(power: power)
        session.start(condition: .duration(60), now: start)

        #expect(session.progress(at: start) == 1)
    }

    @Test func remainingNeverGoesBelowZero() {
        let session = AwakeSession(power: power)
        session.start(condition: .duration(60), now: start)

        #expect(session.remaining(at: start.addingTimeInterval(120)) == 0)
    }
}
