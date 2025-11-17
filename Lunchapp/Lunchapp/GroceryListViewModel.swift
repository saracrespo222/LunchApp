//
//  GroceryListViewModel.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 16/11/25.
//

// GroceryListViewModel.swift
import Foundation
import SwiftUI
import Combine

final class GroceryListViewModel: ObservableObject {
    @Published var items: [GroceryItem] = []

    init() {
        loadItems()
    }

    func addItem(_ item: GroceryItem) {
        items.append(item)
        saveItems()
    }

    func updateItem(_ updatedItem: GroceryItem) {
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            items[index] = updatedItem
            saveItems()
        }
    }

    // Este nombre debe coincidir con el usado en .onDelete(perform:)
    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveItems()
    }

    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "MySuppliesItems")
        }
    }

    private func loadItems() {
        if let savedData = UserDefaults.standard.data(forKey: "MySuppliesItems"),
           let decoded = try? JSONDecoder().decode([GroceryItem].self, from: savedData) {
            items = decoded
        }
    }
}
