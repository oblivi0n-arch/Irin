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
}
