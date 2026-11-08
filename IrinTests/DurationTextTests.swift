import Foundation
import Testing
@testable import Irin

struct DurationTextTests {
    let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Warsaw")!
        return calendar
    }()

    func date(day: Int, hour: Int, minute: Int) -> Date {
        calendar.date(from: DateComponents(year: 2026, month: 11, day: day, hour: hour, minute: minute))!
    }
    
    @Test(arguments: zip(
        [0, 0.3, 59, 60, 3600, 5047],
        ["0:00", "0:01", "0:59", "1:00", "1:00:00", "1:24:07"]
    ))
    func clock(_ interval: TimeInterval, expected: String) {
        #expect(DurationText.clock(interval) == expected)
    }
    
    @Test(arguments: [
        (15, "15 min"),
        (60, "1 h"),
        (90, "1 h 30 min"),
        (24 * 60, "24 h"),
    ])
    func short(minutes: Int, expected: String) {
        #expect(DurationText.short(minutes: minutes) == expected)
    }

    @Test(arguments: [
        (0, "00:00"),
        (17 * 60 + 45, "17:45"),
    ])
    func timeOfDay(minutes: Int, expected: String) {
        #expect(DurationText.timeOfDay(minutes: minutes) == expected)
    }
    
    @Test func endLaterTodayIsNotTomorrow() {
        let now = date(day: 7, hour: 22, minute: 0)
        #expect(DurationText.isTomorrow(date(day: 7, hour: 23, minute: 45), from: now, calendar: calendar) == false)
    }

    @Test func endPastMidnightIsTomorrow() {
        let now = date(day: 7, hour: 22, minute: 0)
        #expect(DurationText.isTomorrow(date(day: 8, hour: 2, minute: 0), from: now, calendar: calendar))
    }
}
