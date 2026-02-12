import SwiftUI

struct PinnedItemsListView: View {
    @Bindable var viewModel: ClipboardViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.pinnedItems) { item in
                    PinnedItemRowView(item: item, viewModel: viewModel)
                    Divider()
                        .padding(.horizontal, 16)
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}
