//
//  DataModels.swift
//  BruinCafeApp-iOS
//
//  Created by Eli Feaster on 11/19/26.
//

import Foundation

// MARK: - Enums

enum Course: String, Codable, CaseIterable {
    case appetizer = "appetizer"
    case entree = "entree"
    case dessert = "dessert"
}

enum StockStatus: String {
    case inStock = "In Stock"
    case lowStock = "Low Stock"
    case soldOut = "Sold Out"
}

// MARK: - Models

struct CafeLocation: Identifiable, Codable {
    let id: String
    let displayName: String
    let subtitle: String
    let sortOrder: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case subtitle
        case sortOrder = "sort_order"
    }
}

struct MealPeriodDef: Identifiable, Codable {
    let id: String
    let label: String
    let startTime: Date
    let endTime: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "name"
        case label
        case startTime = "start_time"
        case endTime = "end_time"
    }
    
    func contains(_ time: Date) -> Bool {
        // Note: Since `Date` objects contain time and date data,
        // we have to compare time components or assume the times
        // are set to be the same day.
        
        if startTime <= endTime {
            return time >= startTime && time < endTime
        } else {
            return time >= startTime || time < endTime
        }
    }
}

struct MenuItem: Identifiable, Codable, Hashable {
    let id: String
    let locationId: String
    let mealPeriod: String // "breakfast", "lunch", "cafe", or "holiday"
    let name: String
    let description: String?
    let course: String
    let menuDate: String?
    let dayOfWeek: String?
    let isClosed: Bool
    let closedMessage: String?
    let sortOrder: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case locationId = "location_id"
        case mealPeriod = "meal_period"
        case name
        case description
        case course
        case menuDate = "menu_date"
        case dayOfWeek = "day_of_week"
        case isClosed = "is_closed"
        case closedMessage = "closed_message"
        case sortOrder = "sort_order"
    }
    
    var categoryLabel: String {
        if mealPeriod == "cafe" {
            return "Café"
        } else {
            return mealPeriod.capitalized
        }
    }
}

struct DayMenu: Identifiable, Codable {
    let id: String = UUID().uuidString
    let dayOfWeek: String
    let date: String // "YYYY-MM-DD"
    let isClosed: Bool
    let closedMessage: String?
    let items: [MenuItem]
    
    enum CodingKeys: String, CodingKey {
        case dayOfWeek = "day_of_week"
        case isClosed = "is_closed"
        case closedMessage = "closed_message"
        case date, items
    }
}

struct InventoryItem: Identifiable, Codable {
    let id: String
    let itemName: String
    let locationId: String
    var quantityOnHand: Int
    let lowStockThreshold: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case itemName = "item_name"
        case locationId = "location_id"
        case quantityOnHand = "quantity_on_hand"
        case lowStockThreshold = "low_stock_threshold"
    }
    
    var status: StockStatus {
        if quantityOnHand <= 0 { return .soldOut }
        if quantityOnHand <= lowStockThreshold { return .lowStock }
        return .inStock
    }
    
}

struct CartLine: Identifiable, Codable {
    var id = UUID()
    let item: MenuItem
    var quantity: Int
}

// MARK: - API Mapping Models

struct MenuRow: Codable {
    let id: String
    let menuDate: String?
    let dayOfWeek: String?
    let isClosed: Bool
    let closedMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case menuDate = "menu_date"
        case dayOfWeek = "day_of_week"
        case isClosed = "is_closed"
        case closedMessage = "closed_message"
    }
}

struct SpecialItem: Identifiable, Codable {
    let id: String
    let locationId: String
    let kind: String // "cafe" | "holiday"
    let holidayName: String?
    let name: String
    let description: String
    let course: String
    let madeToOrder: Bool
    let activeFrom: String?
    let activeUntil: String?
    let sortOrder: Int
    
    enum CodingKeys: String, CodingKey {
        case id, kind, name, description, course
        case locationId = "location_id"
        case holidayName = "holiday_name"
        case madeToOrder = "made_to_order"
        case activeFrom = "active_from"
        case activeUntil = "active_until"
        case sortOrder = "sort_order"
    }
}

struct InventoryRow: Codable {
    let itemId: String
    let quantityOnHand: Int
    let lowStockThreshold: Int
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
        case quantityOnHand = "quantity_on_hand"
        case lowStockThreshold = "low_stock_threshold"
    }
}
