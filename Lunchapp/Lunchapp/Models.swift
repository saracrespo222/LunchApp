//
//  Models.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 12/11/25.
//

import Foundation

struct GroceryItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var quantity: Int = 1
    var isChecked: Bool = false
    var reminderDate: Date? = nil
}

struct GroceryList: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var createdAt: Date = Date()
    var items: [GroceryItem] = []
}
