import Foundation

struct CustomTime: Equatable {
    enum Mode: Equatable {
        case duration
        case until
    }

    static let step = 15
    static let durationRange = 15...(24 * 60)
    private static let minutesPerDay = 24 * 60

    private(set) var mode: Mode = .duration
    private(set) var durationMinutes = 90
    private(set) var untilMinutes: Int

    init(now: Date = .now, calendar: Calendar = .current) {
        untilMinutes = Self.defaultUntil(now: now, calendar: calendar)
    }

    mutating func select(_ newMode: Mode, now: Date = .now, calendar: Calendar = .current) {
        if newMode == .until && mode != .until {
            untilMinutes = Self.defaultUntil(now: now, calendar: calendar)
        }
        mode = newMode
    }

    private static func defaultUntil(now: Date, calendar: Calendar) -> Int {
        let parts = calendar.dateComponents([.hour, .minute], from: now)
        let minutes = (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
        let nextStep = (minutes / step + 1) * step
        return (nextStep + 60) % minutesPerDay
    }

    mutating func increase() { change(by: Self.step) }
    mutating func decrease() { change(by: -Self.step) }

    private mutating func change(by delta: Int) {
        switch mode {
        case .duration:
            let range = Self.durationRange
            durationMinutes = min(max(durationMinutes + delta, range.lowerBound), range.upperBound)
        case .until:
            untilMinutes = (untilMinutes + delta + Self.minutesPerDay) % Self.minutesPerDay
        }
    }

    func condition(after now: Date = .now, calendar: Calendar = .current) -> EndCondition {
        switch mode {
        case .duration:
            .duration(TimeInterval(durationMinutes * 60))
        case .until:
            .until(hour: untilMinutes / 60, minute: untilMinutes % 60, after: now, calendar: calendar)
        }
    }
}
