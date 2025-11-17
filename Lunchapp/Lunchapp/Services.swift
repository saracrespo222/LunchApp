//
//  Services.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 12/11/25.
//

import Foundation
import Combine

final class StorageService: ObservableObject {
    static let shared = StorageService()
    @Published private(set) var lists: [GroceryList] = []

    private var fileURL: URL {
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("listonic_data.json")
    }

    private init() {
        load()
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(lists)
            try data.write(to: fileURL, options: [.atomicWrite])
        } catch {
            print("Error saving lists: \(error)")
        }
    }

    func load() {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([GroceryList].self, from: data)
            self.lists = decoded
        } catch {
            self.lists = []
            print("No existing data or load error: \(error)")
        }
    }

    // CRUD
    func addList(_ list: GroceryList) {
        lists.insert(list, at: 0)
        save()
    }

    func updateList(_ list: GroceryList) {
        if let idx = lists.firstIndex(where: { $0.id == list.id }) {
            lists[idx] = list
            save()
        }
    }

    func deleteList(_ id: UUID) {
        lists.removeAll { $0.id == id }
        save()
    }

    func addItem(_ item: GroceryItem, to listId: UUID) {
        guard let idx = lists.firstIndex(where: { $0.id == listId }) else { return }
        lists[idx].items.append(item)
        save()
    }

    func updateItem(_ item: GroceryItem, in listId: UUID) {
        guard let li = lists.firstIndex(where: { $0.id == listId }) else { return }
        if let ii = lists[li].items.firstIndex(where: { $0.id == item.id }) {
            lists[li].items[ii] = item
            save()
        }
    }

    func deleteItem(_ itemId: UUID, in listId: UUID) {
        guard let li = lists.firstIndex(where: { $0.id == listId }) else { return }
        lists[li].items.removeAll { $0.id == itemId }
        save()
    }
}
