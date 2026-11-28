//
//  CafeStore.swift
//  BruinCafeApp-iOS
//
//  Created by Eli Feaster on 11/19/26.
//

import Foundation

struct StaticStore {
    let locations: [CafeLocation]
    let mealPeriods: [MealPeriodDef]
    let menuRows: [MenuRow]
    let specialItems: [SpecialItem]
}

@Observable
class CafeStore {
    private(set) public var staticValues: StaticStore = StaticStore(
        locations: [],
        mealPeriods: [],
        menuRows: [],
        specialItems: []
    )
    
    public var rewardPunches: Int
    public var inventory: [InventoryRow] = []
    
    public var selectedLocation: CafeLocation? = nil
    public var cart: [MenuItem: Int] = [:]
    
    private(set) public var isLoading: Bool = false
    private(set) public var isLoadedSuccesfully: Bool = false
    
    private let api = SupabaseApi()
    
    public init() {
        // Will fetch `rewardPunches` from persistant storage
        self.rewardPunches = 0
    }
    
    @MainActor
    func refreshData() async {
        self.isLoading = true
        do {
            // Fetch everything in parallel
            async let locations = api.fetchLocations()
            async let mealPeriods = api.fetchMealPeriods()
            async let menuRows = api.fetchMenuRows()
            async let specialItems = api.fetchSpecialItems()
            async let inventory = api.fetchInventory()
            
            let (
                loadedLocations,
                loadedMealPeriods,
                loadedMenuRows,
                loadedSpecialItems,
                loadedInventory
            ) = try await (
                locations,
                mealPeriods,
                menuRows,
                specialItems,
                inventory
            )
            
            self.staticValues = StaticStore(
                locations: loadedLocations,
                mealPeriods: loadedMealPeriods,
                menuRows: loadedMenuRows,
                specialItems: loadedSpecialItems
            )
            
            self.inventory = loadedInventory
            
            // All data is successfully loaded!
            self.isLoadedSuccesfully = true
        } catch {
            print("Failed to loaded data: \(error)")
        }
        
        self.isLoading = false
    }
}

/*@Observable
public class CafeStore {
    public var rewardPunches: Int
    
    public var selectedLocation: String = "hq"
    var menuItems: [MenuItem] = []
    var specialItems: [SpecialItem] = []
    var inventory: [String: Int] = [:]
    
    var isLoading: Bool = false
    
    private let api = SupabaseApi()
    
    init() {}
    
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
*/
