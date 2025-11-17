//
//  ProductCatalog.swift
//  Lunchapp
//
//  Created by Sara Fernanda Crespo Galindo  on 12/11/25.
//

import Foundation

final class ProductCatalog {
    static let shared = ProductCatalog()
    private init() {}

    private let products = [
        "Milk", "Eggs", "Bread", "Butter", "Cheese", "Rice", "Pasta", "Tomato", "Potato", "Onion",
        "Apple", "Banana", "Orange", "Chicken", "Beef", "Fish", "Yogurt", "Cereal", "Coffee", "Tea",
        "Sugar", "Salt", "Pepper", "Oil", "Flour", "Beans", "Lettuce", "Carrot", "Garlic", "Mushroom"
    ]

    func search(_ q: String) -> [String] {
        let trimmed = q.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        return products.filter { $0.localizedCaseInsensitiveContains(trimmed) }
    }
}
