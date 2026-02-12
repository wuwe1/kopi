import SwiftUI

struct ContentView: View {
    @Bindable var viewModel: ClipboardViewModel
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.showingDetail, let item = viewModel.selectedItem {
                ItemDetailView(item: item, viewModel: viewModel)
            } else {
                mainListView
            }
        }
        .onAppear {
            viewModel.refreshCurrentContent()
        }
    }

    private var mainListView: some View {
        VStack(spacing: 0) {
            // Header
            headerView

            Divider()

            // Current Clipboard
            CurrentClipboardView(viewModel: viewModel)

            Divider()

            // Pinned Items List
            if viewModel.pinnedItems.isEmpty {
                EmptyStateView()
            } else {
                PinnedItemsListView(viewModel: viewModel)
            }

            Divider()

            // Footer
            footerView
        }
    }

    private var headerView: some View {
        HStack {
            Text("Kopi")
                .font(.headline)
                .fontWeight(.semibold)

            Spacer()

            Button {
                openSettings()
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Settings")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var footerView: some View {
        HStack {
            Button("Clear All") {
                viewModel.clearAllItems()
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .font(.caption)
            .disabled(viewModel.pinnedItems.isEmpty)

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .font(.caption)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private func openSettings() {
        openWindow(id: "settings")
        // Bring the settings window to front
        NSApp.activate()
    }
}
