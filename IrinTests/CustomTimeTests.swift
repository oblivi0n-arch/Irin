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
        time.select(.until, now: now, calendar: calendar)
        time.increase()

        #expect(time.untilMinutes == 0)
        #expect(time.condition(after: now, calendar: calendar) == .until(date(day: 8, hour: 0, minute: 0)))
    }
    
    @Test func switchingToUntilStartsFromNow() {
        var time = CustomTime(now: date(day: 7, hour: 9, minute: 0), calendar: calendar)
        time.select(.until, now: date(day: 7, hour: 17, minute: 5), calendar: calendar)

        #expect(time.untilMinutes == 18 * 60 + 15)
    }
    
    @Test func passedUntilRefreshesOnReopen() {
        let chosen = date(day: 7, hour: 10, minute: 0)
        var time = CustomTime(now: chosen, calendar: calendar)
        time.select(.until, now: chosen, calendar: calendar)

        time.refreshIfPassed(now: date(day: 7, hour: 14, minute: 0), calendar: calendar)

        #expect(time.untilMinutes == 15 * 60 + 15)
    }

    @Test func pendingUntilSurvivesReopen() {
        let chosen = date(day: 7, hour: 23, minute: 0)
        var time = CustomTime(now: chosen, calendar: calendar)
        time.select(.until, now: chosen, calendar: calendar)

        time.refreshIfPassed(now: date(day: 7, hour: 23, minute: 30), calendar: calendar)

        #expect(time.untilMinutes == 15)
    }
}
