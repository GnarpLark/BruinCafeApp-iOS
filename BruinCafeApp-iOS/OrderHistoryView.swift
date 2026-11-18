//
//  OrderHistoryView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 10/15/26.
//

import SwiftUI

/// Represents a past customer purchase, conforming to Codable for local persistence.
struct PastOrder: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    let orderNumber: Int
    let location: String
    let date: String
    let itemsSummary: String
    let totalAmount: String
    let sampleItemToReorder: MenuItem
}

// MARK: - Central Order Store (Local Persistence)
/// Manages local storage of completed orders and punch card progress in UserDefaults.
final class OrderStore {
    static let shared = OrderStore()
    private let ordersKey = "local_completed_orders"
    private let punchesKey = "user_reward_punches"

    private init() {}

    /// Persists the array of completed orders into UserDefaults as encoded JSON data.
    func saveOrders(_ orders: [PastOrder]) {
        if let data = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(data, forKey: ordersKey)
        }
    }

    /// Loads the stored completed orders from UserDefaults, returning an empty array if none exist.
    func loadOrders() -> [PastOrder] {
        guard let data = UserDefaults.standard.data(forKey: ordersKey),
              let orders = try? JSONDecoder().decode([PastOrder].self, from: data) else {
            return []
        }
        return orders
    }

    /// Persists current reward punches (1...10).
    func savePunches(_ punches: Int) {
        UserDefaults.standard.set(punches, forKey: punchesKey)
    }

    /// Loads the stored reward punch count from UserDefaults, defaulting to 1.
    func loadPunches() -> Int {
        let val = UserDefaults.standard.integer(forKey: punchesKey)
        return val > 0 ? val : 1
    }
}

/// Order History View
///
/// Displays completed customer purchases combining both active local session orders
/// and mock historical records.
///
/// Features:
/// - Real-time sync with `completedOrders` array and persistent storage in `OrderStore`.
/// - Visual "Recent Local" tag on newly simulated local orders.
/// - Active "Reorder" button that switches to the order's location, decrements stock, and loads the item into the cart.
struct OrderHistoryView: View {
    // MARK: - Bindings
    @Binding var selectedLocation: String
    @Binding var cartItems: [MenuItem: Int]
    @Binding var globalStock: [String: Int]
    @Binding var rewardPunches: Int
    @Binding var completedOrders: [PastOrder]
    
    // MARK: - State Properties
    @State private var showingLocationSheet = false
    @State private var showAlert = false

    // MARK: - Initializer with Fallback Defaults
    init(
        selectedLocation: Binding<String>,
        cartItems: Binding<[MenuItem: Int]>,
        globalStock: Binding<[String: Int]>,
        rewardPunches: Binding<Int> = .constant(1),
        completedOrders: Binding<[PastOrder]> = .constant([])
    ) {
        self._selectedLocation = selectedLocation
        self._cartItems = cartItems
        self._globalStock = globalStock
        self._rewardPunches = rewardPunches
        self._completedOrders = completedOrders
    }

    // Static sample orders to populate the historical list
    let pastOrders = [
        PastOrder(
            orderNumber: 4821,
            location: "Bruin Cafe HQ",
            date: "Yesterday, 8:45 AM",
            itemsSummary: "HQ Signature Espresso (2), Breakfast Burrito (1)",
            totalAmount: "$12.50",
            sampleItemToReorder: MenuItem(name: "HQ Signature Espresso", description: "Double shot dark roast espresso", price: "$3.00", stockQuantity: 12)
        ),
        PastOrder(
            orderNumber: 3109,
            location: "Bruin Cafe TC",
            date: "Oct 12, 2026",
            itemsSummary: "Tech Center Special Roast (1), Bruin Bagel (1)",
            totalAmount: "$7.50",
            sampleItemToReorder: MenuItem(name: "Tech Center Special Roast", description: "Fresh drip coffee with caramel", price: "$3.50", stockQuantity: 10)
        )
    ]

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 12) {
            // MARK: Header Navigation Bar
            HStack {
                Button(action: { showingLocationSheet = true }) {
                    Text("Location")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray)
                        .foregroundColor(Color(.white))
                        .cornerRadius(8)
                }
                
                Spacer()

                NavigationLink(destination: CartView(
                    selectedLocation: $selectedLocation,
                    cartItems: $cartItems,
                    globalStock: $globalStock,
                    rewardPunches: $rewardPunches,
                    completedOrders: $completedOrders
                )) {
                    Text("Cart (\(cartItems.values.reduce(0, +)))")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("BrandRed"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingLocationSheet) {
                LocationView(selectedLocation: $selectedLocation, cartItems: $cartItems)
            }

            // MARK: Orders List
            ScrollView {
                VStack(spacing: 15) {
                    Text("Order History")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("BrandBlue"))
                        .padding(.top, 5)

                    Text("Your Past Purchases")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Merge active local session orders with pre-existing sample orders
                    let combinedOrders = completedOrders + pastOrders

                    if combinedOrders.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 40))
                                .foregroundColor(.secondary)
                            Text("No recent orders found.")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)
                    } else {
                        // Render each past order card
                        ForEach(combinedOrders) { order in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Order #\(order.orderNumber)")
                                        .font(.headline)
                                        .foregroundColor(Color("BrandBlue"))
                                    
                                    // Highlight local orders made in current app session
                                    if completedOrders.contains(where: { $0.id == order.id }) {
                                        Text("Recent Local")
                                            .font(.system(size: 10, weight: .bold))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color("BrandGreen").opacity(0.2))
                                            .foregroundColor(Color("BrandGreen"))
                                            .cornerRadius(4)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(order.totalAmount)
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(Color("BrandGreen"))
                                }

                                Text("Location: \(order.location)")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.secondary)

                                Text(order.itemsSummary)
                                    .font(.caption)
                                    .foregroundColor(.primary)

                                HStack {
                                    Text(order.date)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                    
                                    Spacer()

                                    // MARK: Reorder Action Button
                                    // Automatically aligns location, checks stock, and adds sample item to cart
                                    Button(action: {
                                        if selectedLocation != order.location {
                                            cartItems.removeAll()
                                            selectedLocation = order.location
                                        }
                                        let item = order.sampleItemToReorder
                                        let availableStock = globalStock[item.name] ?? item.stockQuantity
                                        
                                       showAlert = true
                                        
                                        if availableStock > 0 {
                                            globalStock[item.name, default: item.stockQuantity] -= 1
                                            cartItems[item, default: 0] += 1
                                        }
                                    }) {
                                        Text("Reorder")
                                            .font(.caption)
                                            .bold()
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color("BrandRed"))
                                            .foregroundColor(.white)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                            .alert("Added Item to Cart", isPresented: self.$showAlert) {
                                Button("OK", role: .cancel) {}
                            }
                            .padding()
                            .background(Color("CardBackground"))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .onAppear {
                // Restore saved orders from UserDefaults if state is empty
                if completedOrders.isEmpty {
                    let loaded = OrderStore.shared.loadOrders()
                    if !loaded.isEmpty {
                        completedOrders = loaded
                    }
                }
            }

            Spacer()

            // MARK: Universal Bottom Navigation Bar
            HStack(spacing: 8) {
                NavigationLink(destination: HomeView(
                    selectedLocation: $selectedLocation,
                    globalStock: $globalStock,
                    rewardPunches: $rewardPunches,
                    completedOrders: $completedOrders
                )) {
                    Text("Home")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color("BrandBlue"))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray)
                }

                Button(action: {}) {
                    Text("News")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color("BrandBlue"))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray)
                }

                NavigationLink(destination: OrderHistoryView(
                    selectedLocation: $selectedLocation,
                    cartItems: $cartItems,
                    globalStock: $globalStock,
                    rewardPunches: $rewardPunches,
                    completedOrders: $completedOrders
                )) {
                    Text("Order History")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(.black))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview Provider
struct OrderHistoryView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        @State var mockCart: [MenuItem: Int] = [:]
        @State var mockStock: [String: Int] = [:]
        @State var mockPunches = 1
        @State var mockOrders: [PastOrder] = []
        
        var body: some View {
            NavigationStack {
                OrderHistoryView(
                    selectedLocation: $mockLocation,
                    cartItems: $mockCart,
                    globalStock: $mockStock,
                    rewardPunches: $mockPunches,
                    completedOrders: $mockOrders
                )
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
