//
//  AddListView.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 12/11/25.
//


import SwiftUI

struct AddListView: View {
    @EnvironmentObject var storage: StorageService
    @Binding var isPresented: Bool
    @State private var title = ""
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("List name")) {
                    TextField("e.g. Weekly groceries", text: $title)
                }
            }
            .navigationTitle("New List")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let new = GroceryList(title: title.isEmpty ? "Untitled" : title)
                        storage.addList(new)
                        showAlert = true
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                }
            }
            .alert("✅ List Created", isPresented: $showAlert) {
                Button("OK") {
                    isPresented = false
                }
            } message: {
                Text("Your list \"\(title.isEmpty ? "Untitled" : title)\" has been created successfully.")
            }
        }
    }
}
