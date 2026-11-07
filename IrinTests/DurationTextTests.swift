import Foundation
import Testing
@testable import Irin

struct DurationTextTests {
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
}
