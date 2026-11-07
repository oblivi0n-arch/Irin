import Foundation

struct Preset: Identifiable {
    let id: String
    let title: String
    let numeral: String
    let condition: EndCondition

    static let all: [Preset] = [
        Preset(id: "15m", title: "15 min", numeral: "ΙΕʹ", condition: .duration(15 * 60)),
        Preset(id: "30m", title: "30 min", numeral: "Λʹ", condition: .duration(30 * 60)),
        Preset(id: "1h", title: "1 hour", numeral: "Αʹ", condition: .duration(60 * 60)),
        Preset(id: "2h", title: "2 hours", numeral: "Βʹ", condition: .duration(2 * 60 * 60)),
        Preset(id: "4h", title: "4 hours", numeral: "Δʹ", condition: .duration(4 * 60 * 60)),
        Preset(id: "indefinitely", title: "∞", numeral: "ΑΠΕΙΡΟΝ", condition: .indefinitely),
    ]
}
