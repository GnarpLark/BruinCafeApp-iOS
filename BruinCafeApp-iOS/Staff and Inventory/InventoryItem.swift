//
//  MenuInventory.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/8/26.
//

import Foundation

struct InventoryItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: String
    let quantity: Int
    let quantityLabel: String
}
