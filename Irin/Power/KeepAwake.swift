protocol KeepAwake: AnyObject {
    var isActive: Bool { get }
    func activate(_ kind: PowerAssertion.Kind, reason: String)
    func release()
}
