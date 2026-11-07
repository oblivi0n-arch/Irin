import Foundation
import Observation

@Observable
final class AwakeSession {
    enum State: Equatable {
        case resting
        case watching(startedAt: Date, endsAt: Date?)
    }
    
    private(set) var state: State = .resting
    
    var keepsDisplayOn = false {
        didSet {
            guard isWatching, keepsDisplayOn != oldValue else { return }
            power.activate(kind, reason: reason)
        }
    }
    
    var stopsOnLowBattery = false
    
    private(set) var stoppedOnLowBattery = false

    static var lowBatteryPercent: Int {
        Int(lowBatteryLevel * 100)
    }
    
    static let lowBatteryLevel = 0.2

    private var kind: PowerAssertion.Kind {
        keepsDisplayOn ? .display : .system
    }
    
    private let power: any KeepAwake
    private let reason = "\(IrinApp.appName) is keeping your Mac awake"
    
    init(power: any KeepAwake = PowerAssertion()) {
        self.power = power
    }
    
    var isWatching: Bool {
        state != .resting
    }
    
    var endsAt: Date? {
        if case .watching(_, let endsAt) = state {
            return endsAt
        }
        return nil
    }
    
    func start( condition: EndCondition, now: Date = .now) {
        let endsAt: Date? = switch condition {
        case .duration(let seconds): now.addingTimeInterval(seconds)
        case .until(let date): date
        case .indefinitely: nil
        }
        
        if let endsAt, endsAt <= now { return }
        
        stoppedOnLowBattery = false
        power.activate(kind, reason: reason)
        state = .watching(startedAt: now, endsAt: endsAt)
    }
    
    func stop() {
        power.release()
        stoppedOnLowBattery = false
        state = .resting
    }
    
    func remaining(at now: Date = .now) -> TimeInterval? {
        guard case .watching(_, let endsAt?) = state else { return nil }
        return max(0, endsAt.timeIntervalSince(now))
    }
    
    func progress(at now: Date = .now) -> Double? {
        guard case .watching(let startedAt, let endsAt?) = state else { return nil }
        let total = endsAt.timeIntervalSince(startedAt)
        guard total > 0 else { return 0 }
        return min(1, max(0, endsAt.timeIntervalSince(now) / total))
    }

    func expireIfNeeded(at now: Date = .now) {
        if remaining(at: now) == 0 {
            stop()
        }
    }
    
    func stopIfBatteryLow(_ battery: BatteryState?) {
        guard stopsOnLowBattery,
              isWatching,
              let battery,
              battery.isOnBattery,
              battery.level < Self.lowBatteryLevel
        else { return }
        
        stop()
        stoppedOnLowBattery = true
    }
}
