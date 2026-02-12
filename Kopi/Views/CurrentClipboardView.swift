import SwiftUI

struct CurrentClipboardView: View {
    @Bindable var viewModel: ClipboardViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Clipboard")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let content = viewModel.currentClipboardContent, !content.isEmpty {
                    Text(content.trimmedPreview)
                        .font(.system(size: 12))
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Clipboard is empty")
                        .font(.system(size: 12))
                        .foregroundStyle(.tertiary)
                        .italic()
                }
            }

            Spacer()

            Button {
                viewModel.pinCurrentClipboard()
            } label: {
                Image(systemName: "pin.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.orange)
            }
            .buttonStyle(.plain)
            .help("Pin to history")
            .disabled(viewModel.currentClipboardContent?.isEmpty ?? true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}
