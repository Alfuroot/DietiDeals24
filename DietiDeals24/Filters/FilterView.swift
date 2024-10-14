import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategories: [AuctionItemType]

    var body: some View {
        NavigationView {
            List(AuctionItemType.allCases, id: \.self) { category in
                HStack {
                    Text(category.rawValue)
                    Spacer()
                    if selectedCategories.contains(category) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if let index = selectedCategories.firstIndex(of: category) {
                        selectedCategories.remove(at: index)
                    } else {
                        selectedCategories.append(category)
                    }
                }
            }
            .navigationTitle("Filter Categories")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FilterView(
        selectedCategories: .constant([.tecnologia, .casa])
    )
}
