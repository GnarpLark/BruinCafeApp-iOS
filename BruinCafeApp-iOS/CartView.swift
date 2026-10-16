//
//  CartView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 9/30/26.
//

import SwiftUI

struct CartView: View {
    @Binding var selectedLocation: String
    @Binding var cartItems: [MenuItem: Int]
    @Binding var globalStock: [String: Int]
    @State private var showingLocationSheet = false

    var body: some View {
        VStack(spacing: 15) {
            // Header Bar & Location Button
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
                
                Text("Cart (\(cartItems.values.reduce(0, +)))")
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color("BrandOrange"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingLocationSheet) {
                LocationView(selectedLocation: $selectedLocation, cartItems: $cartItems)
            }

            Text("Your Cart")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("BrandBlue"))
                .padding(.top, 5)

            Text("Order Summary - \(selectedLocation)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            // Location Change Warning Notice
            Text("⚠️ Note: Changing your location will empty your cart.")
                .font(.caption)
                .bold()
                .foregroundColor(Color("BrandOrange"))
                .padding(.horizontal)

            if cartItems.isEmpty {
                Spacer()
                Text("Your cart is currently empty.")
                    .foregroundColor(.secondary)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(Array(cartItems.keys), id: \.id) { item in
                            let currentQty = cartItems[item] ?? 0
                            let availableStock = globalStock[item.name] ?? item.stockQuantity

                            CartItemCard(
                                itemName: item.name,
                                itemDescription: item.description,
                                itemPrice: item.price,
                                itemQuantity: currentQty,
                                onAdd: {
                                    if availableStock > 0 {
                                        globalStock[item.name, default: item.stockQuantity] -= 1
                                        cartItems[item, default: 0] += 1
                                    }
                                },
                                onRemove: {
                                    globalStock[item.name, default: item.stockQuantity] += 1
                                    if currentQty > 1 {
                                        cartItems[item]? -= 1
                                    } else {
                                        cartItems.removeValue(forKey: item)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }

            VStack(spacing: 12) {
                NavigationLink(destination: OrderSimulationView(selectedLocation: $selectedLocation, cartItems: $cartItems, globalStock: $globalStock)) {
                    Text("Proceed to Checkout")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(cartItems.isEmpty ? Color.gray : Color("BrandBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(cartItems.isEmpty)

                // Returns to HomeView instead of standard menu
                NavigationLink(destination: HomeView(selectedLocation: $selectedLocation)) {
                    Text("Back to Home")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("LocationCardBackground"))
                        .foregroundColor(Color("BrandBlue"))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
    }
}
struct CartView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        @State var mockCart: [MenuItem: Int] = [
            MenuItem(name: "HQ Signature Espresso", description: "Double shot dark roast", price: "$3.00", stockQuantity: 5): 2
        ]
        @State var mockStock: [String: Int] = ["HQ Signature Espresso": 5]
        var body: some View {
            NavigationStack {
                CartView(selectedLocation: $mockLocation, cartItems: $mockCart, globalStock: $mockStock)
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
