//
//  EditItem.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 12/11/25.
//

import SwiftUI

struct EditItemView: View {
    @EnvironmentObject var storage: StorageService
    var item: GroceryItem
    @Binding var list: GroceryList

    @State private var name: String
    @State private var quantity: Int
    @State private var reminderDate: Date?

    @Environment(\.dismiss) var dismiss

    // Inicializador para copiar valores del item original
    init(item: GroceryItem, list: Binding<GroceryList>) {
        self.item = item
        self._list = list
        _name = State(initialValue: item.name)
        _quantity = State(initialValue: item.quantity)
        _reminderDate = State(initialValue: item.reminderDate)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Name", text: $name)
                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...99)
                }

                Section(header: Text("Reminder")) {
                    // ✅ Toggle para activar/desactivar recordatorio
                    Toggle("Add Reminder", isOn: Binding(
                        get: { reminderDate != nil },
                        set: { newValue in
                            reminderDate = newValue ? Date() : nil
                        }
                    ))

                    // ✅ Solo muestra el DatePicker si hay una fecha activa
                    if reminderDate != nil {
                        DatePicker("Remind me", selection: Binding(
                            get: { reminderDate ?? Date() },
                            set: { reminderDate = $0 }
                        ), displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                    }
                }
            }
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveChanges() {
        var updated = item
        updated.name = name
        updated.quantity = quantity
        updated.reminderDate = reminderDate

        storage.updateItem(updated, in: list.id)
        if let _ = reminderDate {
            NotificationService.shared.scheduleReminder(for: updated, listTitle: list.title)
        } else {
            NotificationService.shared.cancelReminder(for: updated)
        }

        dismiss()
    }
}
