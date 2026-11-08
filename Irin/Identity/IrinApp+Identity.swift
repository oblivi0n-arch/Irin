import Foundation

extension IrinApp {
    static let appName = "Irin"
    
    static let author = "oblivi0n-arch"

    static var signature: String {
        "\(author.uppercased()) \(Inscription.madeBy) · v\(version)"
    }
    
    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }
    
    static let epithet = "ΕΓΡΗΓΟΡΟΙ"
}
