//
//  ContentView.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 11/11/25.
//

import SwiftUI

// This is the main box for everything you see.
struct ContentView: View {
    // This holds all my list data and makes sure it stays on the screen.
    @StateObject private var viewModel = GroceryListViewModel()
    // This switch tells the screen when to show the "Add Item" pop-up.
    @State private var showingAddItemSheet = false
    

    var body: some View {
        NavigationView {
            // This container puts a title bar at the top and lets me go to new screens.
            VStack {
                if viewModel.items.isEmpty {
                    Text("Your Goods list is empty.")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                } else {
                    List {
                        // This is the scrollable table that holds all the rows with my items.
                        ForEach(viewModel.items) { item in
                            ProductRow(item: item) { updatedItem in
                                viewModel.updateItem(updatedItem)
                                // This loop goes over all my items one by one and creates a row for each item.
                            }
                        }
                        .onDelete(perform: viewModel.deleteItem)
                        // This adds the swipe-to-delete function and tells the data manager to delete the item.
                    }
                }
            }
            .navigationTitle("My Goods")
            .toolbar {
            // This is the container for adding buttons to the top navigation bar.
                ToolbarItem(placement: .navigationBarTrailing) {
                    //place the button on the right
                    Button(action: { showingAddItemSheet = true }) {
                        Label("Add item", systemImage: "plus")
                        // This is the button that, when pressed, turns on the switch to show the pop-up screen.
                    }
                }
            }
            .sheet(isPresented: $showingAddItemSheet) {
                // This makes a new screen slide up from the bottom when the switch is turned on.
                AddItemView(viewModel: viewModel, isPresented: $showingAddItemSheet)
                // This is the actual view that lets me add items, and I give it the list manager and the switch so it can close itself.
            }
        }
    }
}

#Preview("ContentView") {
    ContentView()
}
