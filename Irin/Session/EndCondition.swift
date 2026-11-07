import Foundation

enum EndCondition: Equatable {
    case duration(TimeInterval)
    case until(Date)
    case indefinitely
}
