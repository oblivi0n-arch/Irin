import Foundation
import Testing
@testable import Irin

@MainActor
struct EndConditionTests {
    let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Warsaw")!
        return calendar
    }()

    func date(day: Int, hour: Int, minute: Int) -> Date {
        calendar.date(from: DateComponents(year: 2026, month: 11, day: day, hour: hour, minute: minute))!
    }

    @Test func laterTimeStaysToday() {
        let now = date(day: 7, hour: 16, minute: 30)
        let condition = EndCondition.until(hour: 18, minute: 0, after: now, calendar: calendar)

        #expect(condition == .until(date(day: 7, hour: 18, minute: 0)))
    }

    @Test func earlierTimeCrossesMidnight() {
        let now = date(day: 7, hour: 23, minute: 0)
        let condition = EndCondition.until(hour: 1, minute: 30, after: now, calendar: calendar)

        #expect(condition == .until(date(day: 8, hour: 1, minute: 30)))
    }

    @Test func sameTimeMeansTomorrow() {
        let now = date(day: 7, hour: 16, minute: 30)
        let condition = EndCondition.until(hour: 16, minute: 30, after: now, calendar: calendar)

        #expect(condition == .until(date(day: 8, hour: 16, minute: 30)))
    }
    
    @Test func missingSpringHourMovesForward() {
        let now = calendar.date(from: DateComponents(year: 2027, month: 3, day: 28, hour: 1, minute: 0))!
        let condition = EndCondition.until(hour: 2, minute: 30, after: now, calendar: calendar)
        let expected = calendar.date(from: DateComponents(year: 2027, month: 3, day: 28, hour: 3, minute: 0))!

        #expect(condition == .until(expected))
    }

    @Test func repeatedAutumnHourUsesTheFirstOne() {
        let now = calendar.date(from: DateComponents(year: 2027, month: 10, day: 31, hour: 1, minute: 0))!
        let condition = EndCondition.until(hour: 2, minute: 30, after: now, calendar: calendar)

        #expect(condition == .until(now.addingTimeInterval(90 * 60)))
    }
}
