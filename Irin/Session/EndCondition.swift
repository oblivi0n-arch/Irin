import Foundation

enum EndCondition: Equatable {
    case duration(TimeInterval)
    case until(Date)
    case indefinitely
}

extension EndCondition {
    static func until(
        hour: Int,
        minute: Int,
        after now: Date = .now,
        calendar: Calendar = .current
    ) -> EndCondition {
        let time = DateComponents(hour: hour, minute: minute, second: 0)
        let date = calendar.nextDate(after: now, matching: time, matchingPolicy: .nextTime)
        return .until(date ?? now)
    }
}
