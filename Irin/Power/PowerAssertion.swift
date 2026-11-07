import IOKit.pwr_mgt

final class PowerAssertion {
    enum Kind {
        case system
        case display
        
        var assertionType: CFString {
            switch self {
            case .system: kIOPMAssertPreventUserIdleSystemSleep as CFString
            case .display: kIOPMAssertPreventUserIdleDisplaySleep as CFString
            }
        }
    }
    
    private var assertionID: IOPMAssertionID = 0
    private(set) var isActive = false
    
    func activate( kind: Kind, reason: String) {
        release()
        
        let result = IOPMAssertionCreateWithName(
            kind.assertionType,
            IOPMAssertionLevel(kIOPMAssertionLevelOn),
            reason as CFString,
            &assertionID
            )
        isActive = result == kIOReturnSuccess
    }
    
    func release() {
        guard isActive else { return }
        IOPMAssertionRelease(assertionID)
        assertionID = 0
        isActive = false
    }
}
