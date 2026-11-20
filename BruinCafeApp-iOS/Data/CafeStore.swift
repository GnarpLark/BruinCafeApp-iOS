//
//  CafeStore.swift
//  BruinCafeApp-iOS
//
//  Created by Eli Feaster on 11/19/26.
//

import Foundation
import SwiftUI

@Observable
class CafeStore {
    var selectedLocation: String = "hq"
    var menuItems: [MenuItem] = []
    var specialItems: [Specialitem] = []
    var inventory: [String: Int] = [:]
    var isLoading: Bool = false
    
    private let api = SupabaseService()
    
    @MainActor
    func refreshData() async {
        self.isLoading = true
        do {
            // Fetch everything in parallel
            async let items = api.fetchMenu()
            async let specials = api.fetchSpecialItems()
            async let stocks = api.fetchInventory()
            
            let (loadedItems, loadedSpecials, loadedStocks) = try await (items, specials, stocks)
            
            self.menuItems = loadedItems
            self.specialItems = loadedSpecials
            
            //print(menuItems)
            //print(specialItems)
            
            // Convert the array to a Dictionary for easier access
            self.inventory = Dictionary(uniqueKeysWithValues: loadedStocks.map { ($0.id, $0.quantityOnHand) })
        } catch {
            print("Failed to load data: \(error)")
        }
        self.isLoading = false
    }
}
