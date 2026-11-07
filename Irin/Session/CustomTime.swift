import Foundation

struct CustomTime: Equatable {
    enum Mode: Equatable {
        case duration
        case until
    }

    static let step = 15
    static let durationRange = 15...(24 * 60)
    private static let minutesPerDay = 24 * 60

    var mode: Mode = .duration
    private(set) var durationMinutes = 90
    private(set) var untilMinutes: Int

    init(now: Date = .now, calendar: Calendar = .current) {
        let parts = calendar.dateComponents([.hour, .minute], from: now)
        let minutes = (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
        let nextStep = (minutes / Self.step + 1) * Self.step
        untilMinutes = (nextStep + 60) % Self.minutesPerDay
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
