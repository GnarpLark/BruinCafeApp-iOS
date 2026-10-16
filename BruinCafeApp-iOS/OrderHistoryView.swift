//
//  OrderHistoryView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 10/15/26.
//

import SwiftUI

struct PastOrder: Identifiable {
    let id = UUID()
    let orderNumber: Int
    let location: String
    let date: String
    let itemsSummary: String
    let totalAmount: String
    let sampleItemToReorder: MenuItem
}

struct OrderHistoryView: View {
    @Binding var selectedLocation: String
    @Binding var cartItems: [MenuItem: Int]
    @Binding var globalStock: [String: Int]
    @State private var showingLocationSheet = false

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

    var body: some View {
        VStack(spacing: 12) {
            // Header Bar & Location / Cart Buttons
            HStack {
                Button(action: { showingLocationSheet = true }) {
                    Text("Location")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray)
                        .foregroundColor(Color("BrandBlue"))
                        .cornerRadius(8)
                }
                
                Spacer()

                NavigationLink(destination: CartView(selectedLocation: $selectedLocation, cartItems: $cartItems, globalStock: $globalStock)) {
                    Text("Cart (\(cartItems.values.reduce(0, +)))")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("BrandOrange"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingLocationSheet) {
                LocationView(selectedLocation: $selectedLocation, cartItems: $cartItems)
            }

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

                    ForEach(pastOrders) { order in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Order #\(order.orderNumber)")
                                    .font(.headline)
                                    .foregroundColor(Color("BrandBlue"))
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

                                // Active Reorder Action -> Adds item to cart & updates location
                                Button(action: {
                                    if selectedLocation != order.location {
                                        cartItems.removeAll()
                                        selectedLocation = order.location
                                    }
                                    let item = order.sampleItemToReorder
                                    let availableStock = globalStock[item.name] ?? item.stockQuantity
                                    
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
                                        .background(Color("BrandOrange"))
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding()
                        .background(Color("CardBackground"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
            }

            Spacer()

            // Universal Bottom Navigation Bar
            HStack(spacing: 8) {
                NavigationLink(destination: HomeView(selectedLocation: $selectedLocation)) {
                    Text("Home")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color("BrandGreen"))
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

                NavigationLink(destination: OrderHistoryView(selectedLocation: $selectedLocation, cartItems: $cartItems, globalStock: $globalStock)) {
                    Text("Order History")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color("BrandBlue"))
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
        var body: some View {
            NavigationStack {
                OrderHistoryView(selectedLocation: $mockLocation, cartItems: $mockCart, globalStock: $mockStock)
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
