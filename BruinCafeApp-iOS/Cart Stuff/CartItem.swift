//
//  CartItem.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/15/26.
//

import Foundation

struct CartItem: Codable, Identifiable {
    var id = UUID()
    let itemPic: String
    let itemName: String
    let itemDescription: String
    var itemQuantity: Int
    var itemPrice: Double
}
