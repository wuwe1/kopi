import SwiftUI

struct ItemDetailView: View {
    let item: ClipboardItem
    @Bindable var viewModel: ClipboardViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button {
                    viewModel.goBack()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(size: 13))
                }
                .buttonStyle(.plain)
                .foregroundStyle(.blue)

                Spacer()

                Text("Item Detail")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                // Invisible spacer for centering
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .font(.system(size: 13))
                .opacity(0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Divider()

            // Content
            ScrollView {
                Text(item.content)
                    .font(.system(size: 12, design: .monospaced))
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
            }
            .frame(maxHeight: .infinity)

            Divider()

            // Footer
            HStack {
                Text(item.createdAt, format: .dateTime)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)

                Spacer()

                Button {
                    viewModel.copyToClipboard(item)
                } label: {
                    Label("Copy", systemImage: "doc.on.doc")
                        .font(.system(size: 12))
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)

                Button(role: .destructive) {
                    viewModel.deleteItem(item)
                } label: {
                    Label("Delete", systemImage: "trash")
                        .font(.system(size: 12))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
    }
}
