//
//  InventoryView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 9/30/26.
//

import SwiftUI

/// Central Inventory Management View & Single Source of Truth
///
/// Serves as the central repository and single source of truth for all dummy item data,
/// initial stock counts, and location-dependent menus across Bruin Cafe HQ and Bruin Cafe TC.
///
/// Features:
/// - Provides centralized static datasets: `defaultInitialStock`, `cafeItems(for:)`, `lunchDailyMenus(for:)`, and `holidayItems`.
/// - Supports real-time location switching via segmented picker and sheet modal.
/// - Dynamically categorizes and renders Cafe items, Lunch specials, and Holiday items according to the active location.
/// - Allows staff to adjust live stock quantities (+/-) or register new items.
struct InventoryView: View {
    // MARK: - Bindings
    /// Live stock quantities keyed by item name, shared across the whole app.
    @Binding var globalStock: [String: Int]
    /// Active cafe location ("Bruin Cafe HQ" or "Bruin Cafe TC").
    @Binding var selectedLocation: String

    // MARK: - State Properties
    @State private var showingAddAlert = false
    @State private var newName = ""
    @State private var newStock = ""
    @State private var showingLocationSheet = false
    @State private var dummyCart: [MenuItem: Int] = [:]

    // MARK: - Initializer
    init(
        globalStock: Binding<[String: Int]>,
        selectedLocation: Binding<String> = .constant("Bruin Cafe HQ")
    ) {
        self._globalStock = globalStock
        self._selectedLocation = selectedLocation
    }

    // MARK: - Centralized Dummy Data (Single Source of Truth)

    /// Default baseline inventory stock numbers mapped by unique item name.
    static let defaultInitialStock: [String: Int] = [
        "HQ Signature Espresso": 12,
        "Breakfast Burrito": 8,
        "Iced Caramel Macchiato": 6,
        "Tech Center Special Roast": 10,
        "Bruin Bagel": 5,
        "Energy Smoothie": 3,
        // Holiday Specials (Shared across locations)
        "Pumpkin Spice Harvest Latte": 15,
        "Maple Pecan Cranberry Muffin": 10,
        "Spiced Apple Cider Warm-Up": 12,
        "Turkey Cranberry Festive Panini": 8,
        // HQ Lunch
        "Hearty Beef Broth Bowl": 10,
        "Chicken Salad Wraps & Chips": 10,
        "Guinness Beef Stew": 10,
        "Crispy Fried Chicken Sandwich & Waffle Fries": 10,
        "Made-to-Order Flatbreads": 10,
        // TC Lunch
        "BBQ Chicken with Mac & Cheese": 10,
        "Shrimp Fried Rice with Egg Roll": 10,
        "Pepperoni Pizza Flatbread": 10,
        "Beef Stroganoff over Egg Noodles": 10,
        "Hot Ham & Cheese with Potato Soup": 10
    ]

    /// Returns location-specific cafe items (HQ vs. TC).
    static func cafeItems(for location: String) -> [MenuItem] {
        if location == "Bruin Cafe TC" {
            return [
                MenuItem(name: "Tech Center Special Roast", description: "Fresh drip coffee with caramel", price: "$3.50", stockQuantity: 10),
                MenuItem(name: "Bruin Bagel", description: "Everything bagel with cream cheese", price: "$4.00", stockQuantity: 5),
                MenuItem(name: "Energy Smoothie", description: "Strawberry banana protein blend", price: "$5.50", stockQuantity: 3)
            ]
        } else {
            return [
                MenuItem(name: "HQ Signature Espresso", description: "Double shot dark roast espresso", price: "$3.00", stockQuantity: 12),
                MenuItem(name: "Breakfast Burrito", description: "Eggs, bacon, cheddar, salsa", price: "$6.50", stockQuantity: 8),
                MenuItem(name: "Iced Caramel Macchiato", description: "Espresso with vanilla and caramel", price: "$4.75", stockQuantity: 6)
            ]
        }
    }

    /// Holiday menu items shared across all locations.
    static let holidayItems: [MenuItem] = [
        MenuItem(name: "Pumpkin Spice Harvest Latte", description: "Espresso with steamed milk, pumpkin puree, and autumn spice blend.", price: "$4.75", stockQuantity: 15),
        MenuItem(name: "Maple Pecan Cranberry Muffin", description: "Freshly baked seasonal muffin topped with candied pecans.", price: "$3.25", stockQuantity: 10),
        MenuItem(name: "Spiced Apple Cider Warm-Up", description: "Slow-simmered spiced apple cider with a cinnamon stick.", price: "$3.00", stockQuantity: 12),
        MenuItem(name: "Turkey Cranberry Festive Panini", description: "Roasted turkey, cranberry chutney, and provolone on sourdough.", price: "$7.50", stockQuantity: 8)
    ]

    /// Returns location-specific daily lunch schedules (Monday through Friday).
    static func lunchDailyMenus(for location: String) -> [DailyMenu] {
        if location == "Bruin Cafe TC" {
            return [
                DailyMenu(day: "Monday", lunchTitle: "BBQ Chicken with Mac & Cheese", lunchDescription: "Grilled chicken in smoky BBQ sauce with velvety mac & cheese and coleslaw.", price: "$7.00"),
                DailyMenu(day: "Tuesday", lunchTitle: "Shrimp Fried Rice with Egg Roll", lunchDescription: "Grilled shrimp over stir-fried rice with a vegetable egg roll.", price: "$7.50"),
                DailyMenu(day: "Wednesday", lunchTitle: "Pepperoni Pizza Flatbread", lunchDescription: "Flatbread filled with pepperoni and mozzarella with garlic butter.", price: "$6.50"),
                DailyMenu(day: "Thursday", lunchTitle: "Beef Stroganoff over Egg Noodles", lunchDescription: "Beef with onions and mushrooms in a rich sour cream mushroom sauce.", price: "$7.25"),
                DailyMenu(day: "Friday", lunchTitle: "Hot Ham & Cheese with Potato Soup", lunchDescription: "Sliced ham and cheddar on a croissant with warm potato soup.", price: "$6.75")
            ]
        } else {
            return [
                DailyMenu(day: "Monday", lunchTitle: "Hearty Beef Broth Bowl", lunchDescription: "Savory beef broth filled with tender beef and hearty ingredients.", price: "$6.00"),
                DailyMenu(day: "Tuesday", lunchTitle: "Chicken Salad Wraps & Chips", lunchDescription: "Tender chicken in creamy dressing wrapped in a flour tortilla with chips.", price: "$6.50"),
                DailyMenu(day: "Wednesday", lunchTitle: "Guinness Beef Stew", lunchDescription: "Slow-simmered beef in rich Guinness stout gravy with vegetables.", price: "$7.00"),
                DailyMenu(day: "Thursday", lunchTitle: "Crispy Fried Chicken Sandwich & Waffle Fries", lunchDescription: "Golden crispy fried chicken on a toasted bun with waffle fries.", price: "$7.50"),
                DailyMenu(day: "Friday", lunchTitle: "Made-to-Order Flatbreads", lunchDescription: "Custom flatbread with fresh toppings, sauces, and melted cheeses.", price: "$8.00")
            ]
        }
    }

    // MARK: - Dynamic Filtered Item Lists
    /// Cafe items dynamically resolved for the active location.
    var cafeItemsList: [String] {
        InventoryView.cafeItems(for: selectedLocation).map { $0.name }
    }
    
    /// Holiday specials list.
    var holidayItemsList: [String] {
        InventoryView.holidayItems.map { $0.name }
    }
    
    /// Daily lunch items dynamically resolved for the active location.
    var lunchItemsList: [String] {
        InventoryView.lunchDailyMenus(for: selectedLocation).map { $0.lunchTitle }
    }*/
     
    // MARK: - View Body
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Staff Header & Location Controls
            VStack(spacing: 8) {
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color("BrandGreen"))
                            .frame(width: 8, height: 8)
                        Text("Staff Portal - Live Inventory")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                    Spacer()

                    // Modal location selector
                    Button(action: { showingLocationSheet = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                            Text(selectedLocation)
                        }
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    }
                }
                
                // Quick-switch segmented picker between HQ and Tech Center
                Picker("Location", selection: $selectedLocation) {
                    Text("Bruin Cafe HQ").tag("Bruin Cafe HQ")
                    Text("Bruin Cafe TC").tag("Bruin Cafe TC")
                }
                .pickerStyle(.segmented)
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(10)
            .background(Color.black)
            .sheet(isPresented: $showingLocationSheet) {
                LocationView(selectedLocation: $selectedLocation, cartItems: $dummyCart)
            }

            // MARK: Dynamic Inventory Sections
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Active Location Indicator
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(Color("BrandBlue"))
                        Text("Showing stock for:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(selectedLocation)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color("BrandBlue"))
                    }
                    .padding(.vertical, 4)
                    
                    // SECTION 1: Cafe Items (Synced for selected location)
                    StockSectionView(
                        title: "Cafe Items (\(selectedLocation == "Bruin Cafe TC" ? "TC" : "HQ"))",
                        items: cafeItemsList,
                        globalStock: $globalStock
                    )

                    // SECTION 2: Lunch & Breakfast (Synced for selected location)
                    StockSectionView(
                        title: "Lunch & Breakfast (\(selectedLocation == "Bruin Cafe TC" ? "TC" : "HQ"))",
                        items: lunchItemsList,
                        globalStock: $globalStock
                    )

                    // SECTION 3: Holiday Specials (Shared across locations)
                    StockSectionView(
                        title: "Holiday Specials",
                        items: holidayItemsList,
                        globalStock: $globalStock
                    )
                }
                .padding()
            }

            // MARK: Add New Item Action Footer
            VStack(spacing: 15) {
                Button(action: {
                    showingAddAlert = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Inventory Item")
                    }
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("BrandOrange"))
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationTitle("Inventory Management")
        .navigationBarTitleDisplayMode(.inline)
        // Dialog to create custom inventory items
        .alert("Add New Stock Item", isPresented: $showingAddAlert) {
            TextField("Item Name", text: $newName)
            TextField("Initial Stock Quantity", text: $newStock)
            Button("Add") {
                let stock = Int(newStock) ?? 10
                if !newName.isEmpty {
                    globalStock[newName] = stock
                    newName = ""
                    newStock = ""
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

// MARK: - Reusable Stock Section View
/// Renders an item category with current stock counts and +/- modification buttons.
struct StockSectionView: View {
    let title: String
    let items: [String]
    @Binding var globalStock: [String: Int]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3)
                .bold()
                .foregroundColor(Color("BrandBlue"))

            ForEach(items, id: \.self) { itemName in
                let currentStock = globalStock[itemName] ?? 10

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(itemName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("Stock: \(currentStock)")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(currentStock > 0 ? Color("BrandGreen") : .red)
                    }

                    Spacer()

                    // +/- Quantity Control Buttons
                    HStack(spacing: 8) {
                        // Decrement Button
                        Button(action: {
                            if currentStock > 0 {
                                globalStock[itemName] = currentStock - 1
                            }
                        }) {
                            Text("-")
                                .font(.headline)
                                .bold()
                                .frame(width: 32, height: 32)
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }

                        // Increment Button
                        Button(action: {
                            globalStock[itemName] = currentStock + 1
                        }) {
                            Text("+")
                                .font(.headline)
                                .bold()
                                .frame(width: 32, height: 32)
                                .background(Color("BrandGreen"))
                                .foregroundColor(.white)
                                .cornerRadius(6)
                        }
                    }
                }
                .padding()
                .background(Color("CardBackground"))
                .cornerRadius(10)
            }
        }
    }
}

// MARK: - Preview Provider
struct InventoryView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockStock: [String: Int] = InventoryView.defaultInitialStock
        @State var mockLocation = "Bruin Cafe HQ"
        
        var body: some View {
            NavigationStack {
                InventoryView(globalStock: $mockStock, selectedLocation: $mockLocation)
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
