import Foundation

enum DurationText {
    static func clock(_ interval: TimeInterval) -> String {
        let total = Int(max(0, interval).rounded(.up))
        let hours = total / 3600
        let minutes = total % 3600 / 60
        let seconds = total % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    static func short(minutes: Int) -> String {
        let hours = minutes / 60
        let rest = minutes % 60

        switch (hours, rest) {
        case (0, _): return "\(rest) min"
        case (_, 0): return "\(hours) h"
        default: return "\(hours) h \(rest) min"
        }
    }

    static func timeOfDay(minutes: Int) -> String {
        String(format: "%02d:%02d", minutes / 60, minutes % 60)
    }
    
    static func isTomorrow(_ date: Date, from now: Date, calendar: Calendar = .current) -> Bool {
        !calendar.isDate(date, inSameDayAs: now)
    }
}
