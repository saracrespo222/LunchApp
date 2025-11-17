//
//  ProductRow.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 12/11/25.
//

import SwiftUI

struct ProductRow: View {
    @State var item: GroceryItem
    var onUpdate: (GroceryItem) -> Void
    @State private var showOutOfStockAlert = false

    var body: some View {
        HStack {
            Button(action: toggleCheck) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isChecked ? .green : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())

            Text(item.name)
                .strikethrough(item.isChecked)
                .foregroundColor(item.isChecked ? .gray : .primary)

            Spacer()

            Stepper(value: $item.quantity, in: 0...99, step: 1) {
                Text("\(item.quantity)x")
                    .foregroundColor(item.quantity == 0 ? .red : .secondary)
            }
            .frame(width: 120)
            .onChange(of: item.quantity) { newValue in
                handleQuantityChange(newValue)
            }
        }
        .alert("⚠️ Out of Stock", isPresented: $showOutOfStockAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You’ve run out of \(item.name). Remember to add it to your shopping list!")
        }
    }

    private func toggleCheck() {
        item.isChecked.toggle()
        onUpdate(item)
    }

    private func handleQuantityChange(_ newValue: Int) {
        onUpdate(item)

        if newValue == 0 {
            showOutOfStockAlert = true
            // Notificación local inmediata
            NotificationService.shared.showOutOfStockNotification(for: item.name)
        }
    }
}

#Preview("ProductRow - Sample") {
    ProductRow(
        item: GroceryItem(name: "Milk", quantity: 2, isChecked: false),
        onUpdate: { _ in }
    )
}
