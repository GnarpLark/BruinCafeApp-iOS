//
//  HolidayView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 10/15/26.
//

import SwiftUI

struct HolidayView: View {
    @Binding var selectedLocation: String
    @Binding var cartItems: [MenuItem: Int]
    @Binding var globalStock: [String: Int]
    @State private var showingLocationSheet = false

    // Alert states
    @State private var showingAddedAlert = false
    @State private var addedItemName = ""
    @State private var showingNewsAlert = false

    let holidayItems = [
        MenuItem(name: "Pumpkin Spice Harvest Latte", description: "Espresso with steamed milk, pumpkin puree, and autumn spice blend.", price: "$4.75", stockQuantity: 15),
        MenuItem(name: "Maple Pecan Cranberry Muffin", description: "Freshly baked seasonal muffin topped with candied pecans.", price: "$3.25", stockQuantity: 10),
        MenuItem(name: "Spiced Apple Cider Warm-Up", description: "Slow-simmered spiced apple cider with a cinnamon stick.", price: "$3.00", stockQuantity: 12),
        MenuItem(name: "Turkey Cranberry Festive Panini", description: "Roasted turkey, cranberry chutney, and provolone on sourdough.", price: "$7.50", stockQuantity: 8)
    ]

    var body: some View {
        VStack(spacing: 12) {
            // Header Bar with Location & Cart buttons
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
                    Text("Holiday Specials Menu")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("BrandOrange"))
                        .padding(.top)

                    ForEach(holidayItems) { item in
                        let availableStock = globalStock[item.name] ?? item.stockQuantity

                        HStack {
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
                                    .foregroundColor(Color("BrandGreen"))

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
        .navigationTitle("Holiday Specials")
        .navigationBarTitleDisplayMode(.inline)
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

struct HolidayView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        @State var mockCart: [MenuItem: Int] = [:]
        @State var mockStock: [String: Int] = ["Pumpkin Spice Harvest Latte": 15]
        var body: some View {
            NavigationStack {
                HolidayView(selectedLocation: $mockLocation, cartItems: $mockCart, globalStock: $mockStock)
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
