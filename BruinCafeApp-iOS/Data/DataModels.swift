//
//  DataModels.swift
//  BruinCafeApp-iOS
//
//  Created by Eli Feaster on 11/19/26.
//

import Foundation

enum Course: String, Codable {
    case entree, appetizer, dessert
}

struct MenuItem: Identifiable, Hashable, Codable {
    let id: String
    let locationId: String
    let name: String
    let description: String?
    let course: Course
    let mealPeriod: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, course
        case locationId = "location_id"
        case mealPeriod = "meal_period"
    }
}

struct InventoryItem: Identifiable, Codable {
    let id: String // A.K.A "item_id" in Supabase
    let quantityOnHand: Int
    let lowStockThreshold: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case quantityOnHand = "quantity_on_hand"
        case lowStockThreshold = "low_stock_threshold"
    }
}

struct Specialitem: Identifiable, Codable {
    let id: String
    let locationId: String
    let kind: String // "cafe" | "holiday"
    let name: String
    let description: String?
    let course: Course
    let activeFrom: String? // Date string
    let activeUntil: String? // Date string
    
    enum CodingKeys: String, CodingKey {
        case id, kind, name, description, course
        case locationId = "location_id"
        case activeFrom = "active_from"
        case activeUntil = "active_until"
    }
}
