import Foundation

extension IrinApp {
    static let appName = "Irin"
    
    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0.0"
    }
}
