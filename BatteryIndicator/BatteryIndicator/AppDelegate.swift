import Cocoa
import IOKit.ps

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var timer: Timer?
    
    override init() {
            super.init()
            print("BatteryIndicator: AppDelegate is initializing...")
        }

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("BatteryIndicator: App launched")
        setupMenuBar()
        startBatteryMonitoring()
    }

    func setupMenuBar() {
        print("BatteryIndicator: Setting up menu bar")
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.title = "🔋 Battery"
            print("BatteryIndicator: Status item created with title")
        } else {
            print("BatteryIndicator: ERROR - Could not create status button")
        }

        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Battery Information", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
        print("BatteryIndicator: Menu bar setup complete")
    }

    func startBatteryMonitoring() {
        updateBatteryStatus()
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.updateBatteryStatus()
        }
    }

    func updateBatteryStatus() {
        let batteryInfo = getBatteryInfo()
        print("BatteryIndicator: Updating battery status")
        print("  Percentage: \(batteryInfo.percentage ?? -1)")
        print("  Is Charging: \(batteryInfo.isCharging)")
        print("  Is Plugged: \(batteryInfo.isPlugged)")

        var displayText = "🔋"

        if let percentage = batteryInfo.percentage {
            displayText = String(format: "🔋 %.0f%%", percentage)
        }

        if let timeRemaining = batteryInfo.timeRemaining {
            if timeRemaining > 0 {
                let hours = timeRemaining / 60
                let minutes = timeRemaining % 60
                displayText += String(format: " (%dh %dm)", hours, minutes)
            } else if batteryInfo.isCharging {
                displayText += " ⚡"
            }
        } else if batteryInfo.isCharging {
            displayText += " ⚡"
        } else if batteryInfo.isPlugged {
            displayText += " 🔌"
        }

        print("  Display text: '\(displayText)'")

        DispatchQueue.main.async { [weak self] in
            self?.statusItem?.button?.title = displayText
            self?.updateMenu(with: batteryInfo)
        }
    }

    func updateMenu(with info: BatteryInfo) {
        guard let menu = statusItem?.menu else { return }

        var menuText = ""

        if let percentage = info.percentage {
            menuText += String(format: "  Level: %.1f%%\n", percentage)
        }

        if info.isCharging {
            menuText += "  Status: Charging\n"
        } else if info.isPlugged {
            menuText += "  Status: Plugged In\n"
        } else {
            menuText += "  Status: On Battery\n"
        }

        if let timeRemaining = info.timeRemaining, timeRemaining > 0 {
            let hours = timeRemaining / 60
            let minutes = timeRemaining % 60
            menuText += String(format: "  Time Remaining: %dh %dm\n", hours, minutes)
        }

        if let health = info.batteryHealth {
            menuText += String(format: "  Health: %.1f%%", health)
        }

        menu.item(at: 0)?.title = menuText
    }

    func getBatteryInfo() -> BatteryInfo {
        var info = BatteryInfo()

        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array

        for source in sources {
            let description = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as! [String: AnyObject]

            if let currentCapacity = description[kIOPSCurrentCapacityKey] as? Int,
               let maxCapacity = description[kIOPSMaxCapacityKey] as? Int {
                info.currentCapacity = currentCapacity
                info.maxCapacity = maxCapacity
                info.percentage = Double(currentCapacity) / Double(maxCapacity) * 100.0
            }

            if let isCharging = description[kIOPSIsChargingKey] as? Bool {
                info.isCharging = isCharging
            }

            if let powerSourceState = description[kIOPSPowerSourceStateKey] as? String {
                info.isPlugged = (powerSourceState == kIOPSACPowerValue)
            }

            if let timeToEmpty = description[kIOPSTimeToEmptyKey] as? Int {
                if timeToEmpty != -1 {
                    info.timeRemaining = timeToEmpty
                }
            }

            if let designCapacity = description["DesignCapacity"] as? Int,
               let maxCapacity = info.maxCapacity {
                info.batteryHealth = Double(maxCapacity) / Double(designCapacity) * 100.0
            }
        }

        return info
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }
}

struct BatteryInfo {
    var percentage: Double?
    var timeRemaining: Int?
    var isCharging: Bool = false
    var isPlugged: Bool = false
    var currentCapacity: Int?
    var maxCapacity: Int?
    var batteryHealth: Double?
}
