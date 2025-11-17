//
//  ListDetailView.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 12/11/25.
//

import SwiftUI

struct ListDetailView: View {
    @EnvironmentObject var storage: StorageService
    @State var list: GroceryList
    @State private var showingSearch = false
    @State private var showingEdit = false
    @State private var selectedItem: GroceryItem?

    var body: some View {
        List {
            ForEach(list.items) { item in
                ProductRow(item: item) { updated in
                    storage.updateItem(updated, in: list.id)
                    list = storage.lists.first(where: { $0.id == list.id }) ?? list
                }
                .swipeActions {
                    Button(role: .destructive) {
                        storage.deleteItem(item.id, in: list.id)
                        list.items.removeAll { $0.id == item.id }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                    Button {
                        selectedItem = item
                        showingEdit = true
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
        }
        .navigationTitle(list.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingSearch.toggle() }) {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .sheet(isPresented: $showingSearch) {
            SearchView(list: $list)
                .environmentObject(storage)
        }
        .sheet(item: $selectedItem) { item in
            EditItemView(item: item, list: $list)
                .environmentObject(storage)
        }
        .onAppear {
            list = storage.lists.first(where: { $0.id == list.id }) ?? list
        }
    }
}
