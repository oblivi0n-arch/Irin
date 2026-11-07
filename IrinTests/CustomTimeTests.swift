import Foundation
import Testing
@testable import Irin

@MainActor
struct CustomTimeTests {
    let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Warsaw")!
        return calendar
    }()

    func date(day: Int, hour: Int, minute: Int) -> Date {
        calendar.date(from: DateComponents(year: 2026, month: 11, day: day, hour: hour, minute: minute))!
    }

    @Test func untilStartsAnHourAheadOnAQuarter() {
        let time = CustomTime(now: date(day: 7, hour: 16, minute: 38), calendar: calendar)

        #expect(time.untilMinutes == 17 * 60 + 45)
    }

    @Test func durationStopsAtTheMinimum() {
        var time = CustomTime(now: date(day: 7, hour: 16, minute: 38), calendar: calendar)
        for _ in 0..<10 { time.decrease() }

        #expect(time.durationMinutes == 15)
    }

    @Test func untilWrapsPastMidnight() {
        let now = date(day: 7, hour: 22, minute: 38)
        var time = CustomTime(now: now, calendar: calendar)
        time.mode = .until
        time.increase()

        #expect(time.untilMinutes == 0)
        #expect(time.condition(after: now, calendar: calendar) == .until(date(day: 8, hour: 0, minute: 0)))
    }
}
