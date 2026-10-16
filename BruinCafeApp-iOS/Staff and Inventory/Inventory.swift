//
//  InventoryClass.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/8/26.
//

import Foundation

struct Inventory  {
    
    func items(selectedLocation: String) -> [InventoryItem] {
        
        if selectedLocation == "Bruin Cafe TC" {
            return [
                InventoryItem(
                    name: "Tech Center Special Roast",
                    description: "Fresh drip coffee with caramel",
                    price: "$3.50",
                    quantity: 6,
                    quantityLabel: "In Stock"),
                InventoryItem(
                    name: "Bruin Bagel",
                    description: "Everything bagel with cream cheese",
                    price: "$4.00",
                    quantity: 8,
                    quantityLabel: "In Stock"),
                InventoryItem(
                    name: "Energy Smoothie",
                    description: "Strawberry banana protein blend",
                    price: "$5.50",
                    quantity: 3,
                    quantityLabel: "In Stock")
            ]
        } else {
            return [
                InventoryItem(
                    name: "HQ Signature Espresso",
                    description: "Double shot dark roast espresso",
                    price: "$3.00",
                    quantity: 10,
                    quantityLabel: "In Stock"),
                InventoryItem(
                    name: "Breakfast Burrito",
                    description: "Eggs, bacon, cheddar, salsa",
                    price: "$6.50",
                    quantity: 5,
                    quantityLabel: "In Stock"),
                InventoryItem(
                    name: "Iced Caramel Macchiato",
                    description: "Espresso with vanilla and caramel",
                    price: "$4.75",
                    quantity: 11,
                    quantityLabel: "In Stock")
            ]
        }

    }
    
}
