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
}
