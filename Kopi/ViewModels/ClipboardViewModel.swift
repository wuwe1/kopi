import Foundation
import SwiftUI
import GRDB

@MainActor @Observable
final class ClipboardViewModel {
    var currentClipboardContent: String?
    var pinnedItems: [ClipboardItem] = []
    var selectedItem: ClipboardItem?
    var showingDetail: Bool = false
    var searchText: String = ""

    var filteredItems: [ClipboardItem] {
        guard !searchText.isEmpty else { return pinnedItems }
        let query = searchText.lowercased()
        return pinnedItems.filter { $0.content.lowercased().contains(query) }
    }

    private let repository = ClipboardItemRepository()
    private let monitor = ClipboardMonitor()
    private let clipboardService = ClipboardService.shared
    private let settings = AppSettings.shared

    private var observationCancellable: AnyDatabaseCancellable?

    init() {
        setupMonitor()
        startObservation()
    }

    // MARK: - Setup

    private func setupMonitor() {
        monitor.onNewContent = { [weak self] content, contentType in
            guard let self else { return }
            Task { @MainActor in
                if self.settings.autoMonitorEnabled {
                    self.autoSaveContent(content, contentType: contentType)
                }
            }
        }
        monitor.start(interval: settings.pollingInterval)
    }

    private func startObservation() {
        let maxItems = settings.maxItems
        observationCancellable = repository.observeAllItems(
            in: DatabaseManager.shared.dbQueue,
            limit: maxItems
        ) { [weak self] items in
            Task { @MainActor in
                self?.pinnedItems = items
            }
        }
    }

    // MARK: - Actions

    func refreshCurrentContent() {
        currentClipboardContent = clipboardService.readText()
    }

    func pinCurrentClipboard() {
        guard let content = clipboardService.readText(), !content.isEmpty else { return }
        let contentType = clipboardService.detectContentType(content)
        do {
            try repository.pinItem(content: content, contentType: contentType)
            try repository.enforceMaxItems(settings.maxItems)
        } catch {
            print("Pin error: \(error)")
        }
    }

    private func autoSaveContent(_ content: String, contentType: String) {
        do {
            try repository.saveItem(content: content, contentType: contentType)
            try repository.enforceMaxItems(settings.maxItems)
        } catch {
            print("Auto-save error: \(error)")
        }
    }

    func copyToClipboard(_ item: ClipboardItem) {
        clipboardService.writeText(item.content)
        refreshCurrentContent()
    }

    func deleteItem(_ item: ClipboardItem) {
        do {
            try repository.deleteItem(item)
            if selectedItem == item {
                showingDetail = false
                selectedItem = nil
            }
        } catch {
            print("Delete error: \(error)")
        }
    }

    func clearAllItems() {
        do {
            try repository.deleteAllItems()
            showingDetail = false
            selectedItem = nil
        } catch {
            print("Clear all error: \(error)")
        }
    }

    func selectItem(_ item: ClipboardItem) {
        selectedItem = item
        showingDetail = true
    }

    func goBack() {
        showingDetail = false
        selectedItem = nil
    }

    // MARK: - Settings Changes

    func updateMonitoringState() {
        monitor.restart(interval: settings.pollingInterval)
    }

    func updateLaunchAtLogin() {
        LaunchAtLoginService.shared.setEnabled(settings.launchAtLogin)
    }
}
