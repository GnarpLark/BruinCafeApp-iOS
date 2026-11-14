//
//  OrderSimulationView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 10/1/26.
//

import SwiftUI

/// Checkout and Order Simulation View
///
/// Handles checkout review, generates mock order confirmations, captures local completed orders,
/// and powers the dynamic rewards punch card counter.
///
/// Punches & Rewards:
/// - Each confirmed purchase awards 1 punch out of 10.
/// - When 10 punches are reached, free lunch is unlocked.
/// - The subsequent purchase after 10 punches resets the counter back to 1.
/// - All punch updates and order records are persisted in `OrderStore`.
struct OrderSimulationView: View {
    // MARK: - Bindings
    @Binding var selectedLocation: String
    @Binding var cartItems: [MenuItem: Int]
    @Binding var globalStock: [String: Int]
    @Binding var rewardPunches: Int
    @Binding var completedOrders: [PastOrder]

    // MARK: - State Properties
    @State private var isConfirmed = false
    @State private var generatedOrderNumber = Int.random(in: 1000...9999)

    // MARK: - Initializer with Default Fallbacks
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

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 20) {
            if !isConfirmed {
                // MARK: Step 1: Pre-Confirmation Checkout View
                Text("Checkout & Simulation")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("BrandBlue"))
                    .padding(.top, 10)

                Text("Pickup Location: \(selectedLocation)")
                    .font(.headline)
                    .foregroundColor(Color("BrandOrange"))

                // Order items breakdown and calculated total
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Order Summary:")
                            .font(.headline)
                            .padding(.bottom, 5)

                        ForEach(Array(cartItems.keys), id: \.self) { item in
                            HStack {
                                Text("\(item.name) x \(cartItems[item] ?? 1)")
                                    .font(.subheadline)
                                Spacer()
                                Text(item.price)
                                    .font(.subheadline)
                                    .bold()
                            }
                        }

                        Divider()

                        HStack {
                            Text("Total:")
                                .font(.title3)
                                .bold()
                            Spacer()
                            let total = cartItems.reduce(0.0) { sum, entry in
                                let priceString = entry.key.price.replacingOccurrences(of: "$", with: "")
                                let price = Double(priceString) ?? 0.0
                                return sum + (price * Double(entry.value))
                            }
                            Text(String(format: "$%.2f", total))
                                .font(.title3)
                                .bold()
                                .foregroundColor(Color("BrandGreen"))
                        }
                        .padding(.top, 5)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("CardBackground"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                // Action buttons: Confirm Order and Back to Cart
                VStack(spacing: 12) {
                    // MARK: Confirm Order Action
                    Button(action: {
                        isConfirmed = true
                        
                        // Increment rewards punch counter (1 to 10 progression, resetting after 10)
                        if rewardPunches >= 10 {
                            rewardPunches = 1
                        } else {
                            rewardPunches += 1
                        }
                        OrderStore.shared.savePunches(rewardPunches)
                        
                        // Build order summary string
                        let summary = cartItems.map { "\($0.key.name) (\($0.value))" }.joined(separator: ", ")
                        
                        // Calculate formatted price total
                        let totalCents = cartItems.reduce(0.0) { sum, entry in
                            let priceString = entry.key.price.replacingOccurrences(of: "$", with: "")
                            let price = Double(priceString) ?? 0.0
                            return sum + (price * Double(entry.value))
                        }
                        let formattedTotal = String(format: "$%.2f", totalCents)
                        let sampleItem = cartItems.keys.first ?? MenuItem(name: "Default Item", description: "", price: "$0.00", stockQuantity: 10)
                        
                        // Capture readable date/time
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateStyle = .medium
                        dateFormatter.timeStyle = .short
                        let dateString = dateFormatter.string(from: Date())

                        // Construct new persistent PastOrder
                        let newOrder = PastOrder(
                            orderNumber: generatedOrderNumber,
                            location: selectedLocation,
                            date: "\(dateString) (Just now)",
                            itemsSummary: summary,
                            totalAmount: formattedTotal,
                            sampleItemToReorder: sampleItem
                        )
                        
                        // Store order in memory and persist locally in UserDefaults
                        completedOrders.insert(newOrder, at: 0)
                        OrderStore.shared.saveOrders(completedOrders)
                    }) {
                        Text("Confirm Order")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(cartItems.isEmpty ? Color.gray : Color("BrandOrange"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(cartItems.isEmpty)

                    // Back to Cart Navigation
                    NavigationLink(destination: CartView(
                        selectedLocation: $selectedLocation,
                        cartItems: $cartItems,
                        globalStock: $globalStock,
                        rewardPunches: $rewardPunches,
                        completedOrders: $completedOrders
                    )) {
                        Text("Back to Cart")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(Color("BrandBlue"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)

            } else {
                // MARK: Step 2: Post-Confirmation Success View
                Spacer()

                Text("Order Confirmed!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("BrandGreen"))

                Text("Order Number: #\(generatedOrderNumber)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))

                Text("This is a mock order simulation for \(selectedLocation).\nInventory and order history have been recorded.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()

                // MARK: Dynamic Rewards Banner Feedback
                if rewardPunches == 10 {
                    // 10th Punch Reached -> Free Lunch Celebration Banner
                    VStack(spacing: 6) {
                        Text("🎉 FREE LUNCH EARNED! 🎉")
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color("BrandGreen"))
                        Text("You reached 10 / 10 punches! Enjoy your free lunch. Next order starts your new card.")
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("BrandGreen").opacity(0.12))
                    .cornerRadius(10)
                    .padding(.horizontal)
                } else {
                    // Standard Punch Count Status (1...9)
                    HStack(spacing: 6) {
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(Color("BrandOrange"))
                        Text("Rewards Punch Recorded: \(rewardPunches) / 10 (\(10 - rewardPunches) more for free lunch)")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(Color("BrandBlue"))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("CardBackground"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                Spacer()

                // MARK: Start New Order (Clears active cart & navigates back to HomeView)
                NavigationLink(destination: HomeView(
                    selectedLocation: $selectedLocation,
                    globalStock: $globalStock,
                    rewardPunches: $rewardPunches,
                    completedOrders: $completedOrders
                )) {
                    Text("Start New Order")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("BrandBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
                .simultaneousGesture(TapGesture().onEnded {
                    // Clear the shopping cart for subsequent orders
                    cartItems.removeAll()
                })
            }
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationTitle(isConfirmed ? "Confirmation" : "Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview Provider
struct OrderSimulationView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        @State var mockCart: [MenuItem: Int] = [:]
        @State var mockStock: [String: Int] = [:]
        @State var mockPunches = 1
        @State var mockOrders: [PastOrder] = []
        
        var body: some View {
            NavigationStack {
                OrderSimulationView(
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
