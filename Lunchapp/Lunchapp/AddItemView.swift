//
//  AddItemView.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 16/11/25.
//

import SwiftUI

struct AddItemView: View {
    // This is where I receive the list manager from the main screen so I can use it to save new items.
    @ObservedObject var viewModel: GroceryListViewModel
    // This is where I receive the list from the main screen so I can use it to save new items.
    @Binding var isPresented: Bool
    //so I can close this pop-up.
    @State private var searchText = ""
    //holds the text that the user types in the search bar
    @State private var filteredProducts: [String] = []
    @State private var showingConfirmation = false
    @State private var selectedItemName: String?

    // Basic list of products names that we can use for search suggestions
    let allProducts = [
        "Milk", "Eggs", "Bread", "Cheese", "Butter", "Apples",
        "Bananas", "Tomatoes", "Rice", "Pasta", "Juice", "Chicken",
        "Coffee", "Sugar", "Flour", "Yogurt", "Cereal", "Carrots"
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // This is the search bar where the user can type and I link it to the text variable.
                TextField("Search item...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // These lines make the search box look nice with rounded edges and add some space around it.
                    .padding()

                // This shows the suggested items ONLY if the list of filtered products is NOT empty.
                if !filteredProducts.isEmpty {
                    // This creates a scrollable row for every item that matches the search.
                    List(filteredProducts, id: \.self) { product in
                        Button(action: {
                            addItem(product)
                        }) {
                            Text(product)
                        }
                    }
                    // If there are no matches, this shows a button that lets the user add exactly what they typed.
                } else if !searchText.isEmpty {
                    Button(action: {
                        addItem(searchText)
                    }) {
                        Label("Add \"\(searchText)\"", systemImage: "plus.circle")
                            .foregroundColor(.blue)
                    }
                    .padding()
                } else {
                    Text("Start typing to search or add new items")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                }

                Spacer()
                //this pushes all the content up to the top of the screen
            }
            // This adds a "Cancel" button on the left that closes this screen when pressed.
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isPresented = false }
                }
            }
            .onChange(of: searchText) {
                filterProducts()
                // This watches the search box and runs the filter function every time the text changes.
            }
            .alert("Item Added", isPresented: $showingConfirmation) {
                Button("OK") {
                    isPresented = false // Closes and go back to main page
                }
            } message: {
                Text("\(selectedItemName ?? "Item") has been added to your list.")
            }
            // This makes a small confirmation pop-up appear when an item is added, and the OK button closes the whole screen.
        }
    }

    private func filterProducts() {
        if searchText.isEmpty {
            filteredProducts = []
        } else {
            filteredProducts = allProducts.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
            // This function looks for products in the basic list that match what the user is typing.
        }
    }

    private func addItem(_ name: String) {
        let newItem = GroceryItem(name: name, quantity: 1)
        viewModel.addItem(newItem)
        selectedItemName = name
        showingConfirmation = true
        // This function creates the new item, saves it to the list manager, and turns on the confirmation pop-up.
    }
}

#Preview("AddItemView Preview") {
    // Preview wrapper to provide required dependencies
    struct AddItemPreviewWrapper: View {
        @StateObject private var vm = Lunchapp.GroceryListViewModel()
        @State private var isPresented = true

        var body: some View {
            AddItemView(viewModel: vm, isPresented: $isPresented)
        }
    }
    return AddItemPreviewWrapper()
}
