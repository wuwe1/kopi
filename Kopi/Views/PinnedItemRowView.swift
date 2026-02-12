import SwiftUI

struct PinnedItemRowView: View {
    let item: ClipboardItem
    @Bindable var viewModel: ClipboardViewModel

    var body: some View {
        Button {
            viewModel.selectItem(item)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.preview)
                        .font(.system(size: 12))
                        .lineLimit(2)
                        .foregroundStyle(.primary)

                    Text(item.updatedAt.relativeDescription)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }

                Spacer()

                if item.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(.orange.opacity(0.6))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                viewModel.copyToClipboard(item)
            } label: {
                Label("Copy", systemImage: "doc.on.doc")
            }

            Divider()

            Button(role: .destructive) {
                viewModel.deleteItem(item)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: - Date Extension

extension Date {
    var relativeDescription: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
