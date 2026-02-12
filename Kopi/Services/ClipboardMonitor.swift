import Foundation
import AppKit

@MainActor @Observable
final class ClipboardMonitor {
    private var timer: Timer?
    private var lastChangeCount: Int = 0
    private let clipboardService = ClipboardService.shared

    var currentContent: String?
    var onNewContent: ((String, String) -> Void)?

    var isMonitoring: Bool = false

    func start(interval: TimeInterval = Constants.defaultPollingInterval) {
        guard timer == nil else { return }
        lastChangeCount = clipboardService.currentChangeCount
        currentContent = clipboardService.readText()
        isMonitoring = true

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        isMonitoring = false
    }

    func restart(interval: TimeInterval = Constants.defaultPollingInterval) {
        stop()
        start(interval: interval)
    }

    private func checkClipboard() {
        let newChangeCount = clipboardService.currentChangeCount
        guard newChangeCount != lastChangeCount else { return }
        lastChangeCount = newChangeCount

        guard let text = clipboardService.readText(), !text.isEmpty else { return }
        currentContent = text
        let contentType = clipboardService.detectContentType(text)
        onNewContent?(text, contentType)
    }
}
