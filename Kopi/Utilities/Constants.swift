import Foundation

enum Constants {
    static let appName = "Kopi"

    // MARK: - Paths
    static let kopiDirectoryURL: URL = {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return home.appendingPathComponent(".kopi", isDirectory: true)
    }()

    static let databaseURL: URL = {
        kopiDirectoryURL.appendingPathComponent("kopi.db")
    }()

    // MARK: - Defaults
    static let defaultMaxItems = 50
    static let defaultPollingInterval: TimeInterval = 0.5
    static let previewMaxLength = 100

    // MARK: - UserDefaults Keys
    enum SettingsKeys {
        static let maxItems = "maxItems"
        static let autoMonitorEnabled = "autoMonitorEnabled"
        static let pollingInterval = "pollingInterval"
        static let launchAtLogin = "launchAtLogin"
    }
}
