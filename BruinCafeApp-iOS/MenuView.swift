//
//  MenuView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/30/26.
//

import SwiftUI

struct MenuView: View {
    @Binding var selectedLocation: String
    @Binding var cartItems: [MenuItem: Int]
    @Binding var globalStock: [String: Int]
    @State private var showingLocationSheet = false
    @Environment(\.dismiss) var dismiss

    // Alert states
    @State private var showingAddedAlert = false
    @State private var addedItemName = ""
    @State private var showingNewsAlert = false

    var menuItems: [MenuItem] {
        if selectedLocation == "Bruin Cafe TC" {
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

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                // Circular Chevron Back Button
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 38, height: 38)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 1)
                }

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

            Text("\(selectedLocation) Menu")
                .font(.title2)
                .bold()
                .foregroundColor(Color("BrandBlue"))
                .padding(.top, 5)

            ScrollView {
                VStack(spacing: 15) {
                    ForEach(menuItems) { item in
                        let availableStock = globalStock[item.name] ?? item.stockQuantity
                         
                        HStack {
                            ZStack {
                                Color.gray
                                Text("Image")
                                    .foregroundColor(Color("BrandPurple"))
                                    .bold()
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(Color("BrandBlue"))
                                Text(item.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(item.price)
                                    .font(.subheadline)
                                    .bold()
                               
                                Text("In Stock: \(availableStock)")
                                    .font(.footnote)
                                    .foregroundColor(availableStock > 0 ? Color("BrandGreen") : .red)
                                    .bold()
                            }

                            Spacer()

                            Button(action: {
                                if availableStock > 0 {
                                    globalStock[item.name] = availableStock - 1
                                    cartItems[item, default: 0] += 1
                                    addedItemName = item.name
                                    showingAddedAlert = true
                                }
                            }) {
                                Text(availableStock <= 0 ? "Sold Out" : "Add to Cart")
                                    .font(.caption)
                                    .bold()
                                    .padding(8)
                                    .frame(minWidth: 80)
                                    .background(availableStock <= 0 ? Color.gray : Color("BrandOrange"))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }
                            .disabled(availableStock <= 0)
                        }
                        .padding()
                        .background(Color("CardBackground"))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
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

                Button(action: {
                    showingNewsAlert = true
                }) {
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
        .navigationBarBackButtonHidden(true)
        .alert("Added to Cart", isPresented: $showingAddedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(addedItemName) was successfully added to your cart.")
        }
        .alert("News Unavailable", isPresented: $showingNewsAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The news page is currently unavailable.")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        @State var mockCart: [MenuItem: Int] = [:]
        @State var mockStock: [String: Int] = ["HQ Signature Espresso": 12]
        var body: some View {
            NavigationStack {
                MenuView(selectedLocation: $mockLocation, cartItems: $mockCart, globalStock: $mockStock)
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
