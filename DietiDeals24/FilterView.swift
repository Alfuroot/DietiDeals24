//
//  FilterView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 26/08/2024.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCategories: [String]
    let availableCategories: [String]

    var body: some View {
        NavigationView {
            List(availableCategories, id: \.self) { category in
                HStack {
                    Text(category)
                    Spacer()
                    if selectedCategories.contains(category) {
                        Image(systemName: "checkmark")
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
                        selectedCategories = []
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
        selectedCategories: .constant(["Fruits", "Vegetables"]),
        availableCategories: ["Fruits", "Vegetables", "Dairy", "Meat", "Grains", "Snacks", "Beverages"]
    )
}
