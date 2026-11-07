import IOKit.ps

struct BatteryState: Equatable {
    let level: Double
    let isOnBattery: Bool
}

protocol BatteryReading {
    func current() -> BatteryState?
}

final class SystemBattery: BatteryReading {
    func current() -> BatteryState? {
        let info = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(info).takeRetainedValue() as Array

        for source in sources {
            guard
                let description = IOPSGetPowerSourceDescription(info, source)?
                    .takeUnretainedValue() as? [String: Any],
                description[kIOPSTypeKey] as? String == kIOPSInternalBatteryType,
                let current = description[kIOPSCurrentCapacityKey] as? Int,
                let maximum = description[kIOPSMaxCapacityKey] as? Int,
                maximum > 0
            else { continue }

            let state = description[kIOPSPowerSourceStateKey] as? String
            return BatteryState(
                level: Double(current) / Double(maximum),
                isOnBattery: state == kIOPSBatteryPowerValue
            )
        }
        return nil
    }
}
