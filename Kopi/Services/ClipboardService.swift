import AppKit

@MainActor
final class ClipboardService {
    static let shared = ClipboardService()

    private let pasteboard = NSPasteboard.general

    private init() {}

    var currentChangeCount: Int {
        pasteboard.changeCount
    }

    func readText() -> String? {
        pasteboard.string(forType: .string)
    }

    func writeText(_ text: String) {
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    func detectContentType(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let url = URL(string: trimmed), url.scheme != nil, url.host != nil {
            return "url"
        }
        return "text"
    }
}
