//
//  MenuItem.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/30/26.
//

import SwiftUI

/// Core data model representing an item available for purchase at Bruin Cafe.
/// Conforms to `Identifiable`, `Hashable`, and `Codable` to support SwiftUI lists,
/// dictionary keyed carts (`[MenuItem: Int]`), and persistence in `OrderStore`.
struct MenuItem: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    let name: String
    let description: String
    let price: String
    var stockQuantity: Int
}
