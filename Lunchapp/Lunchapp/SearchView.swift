//
//  SearchView.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 12/11/25.
//


import SwiftUI

struct SearchView: View {
    @EnvironmentObject var storage: StorageService
    @Binding var list: GroceryList
    @State private var query = ""
    @State private var results: [String] = []
    @State private var showAlert = false
    @State private var addedProductName = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search product...", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: query) { newValue in
                        results = ProductCatalog.shared.search(newValue)
                    }

                List(results, id: \.self) { product in
                    Button {
                        let newItem = GroceryItem(name: product)
                        storage.addItem(newItem, to: list.id)
                        list.items.append(newItem)
                        addedProductName = product
                        showAlert = true
                    } label: {
                        HStack {
                            Text(product)
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("Add Items")
            .alert("🛒 Product Added", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("“\(addedProductName)” has been added to your shopping list successfully.")
            }
        }
    }
}
