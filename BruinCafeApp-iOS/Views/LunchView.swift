//
//  LunchView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 10/15/26.
//

import SwiftUI

struct DailyMenu: Identifiable {
    let id = UUID()
    let day: String
    let lunchTitle: String
    let lunchDescription: String
    let price: String
}

struct LunchView: View {
    @Binding var selectedLocation: String
    @Binding var cartItems: [MenuItem: Int]
    @Binding var globalStock: [String: Int]
    @Binding var rewardPunches: Int
    @Binding var completedOrders: [PastOrder]

    @State private var showingLocationSheet = false

    // Alert states
    @State private var showingAddedAlert = false
    @State private var addedItemName = ""
    @State private var showingNewsAlert = false

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

    var currentDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }

    // Centralized single source of truth from InventoryView
    var hqMenus: [DailyMenu] {
        InventoryView.lunchDailyMenus(for: "Bruin Cafe HQ")
    }

    var tcMenus: [DailyMenu] {
        InventoryView.lunchDailyMenus(for: "Bruin Cafe TC")
    }

    var todayMenu: DailyMenu {
        let menus = (selectedLocation == "Bruin Cafe TC") ? tcMenus : hqMenus
        return menus.first(where: { $0.day.lowercased() == currentDayString.lowercased() }) ?? menus[0]
    }

    var body: some View {
        let lunchMenuItem = MenuItem(name: todayMenu.lunchTitle, description: todayMenu.lunchDescription, price: todayMenu.price, stockQuantity: 10)
        let availableStock = globalStock[lunchMenuItem.name] ?? 10

        VStack(spacing: 12) {
            // Header Bar with Location & Cart buttons
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

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("\(selectedLocation) Today's Lunch")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color("BrandBlue"))
                            .multilineTextAlignment(.center)

                        Text("Serving hours: 11:00 AM - 1:30 PM")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)

                    // Daily Special Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(todayMenu.day.uppercased())
                                .font(.caption)
                                .bold()
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color("BrandOrange"))
                                .foregroundColor(.white)
                                .cornerRadius(4)

                            Spacer()

                            Text(todayMenu.price)
                                .font(.title3)
                                .bold()
                                .foregroundColor(Color("BrandGreen"))
                        }

                        Text(todayMenu.lunchTitle)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)

                        Text(todayMenu.lunchDescription)
                            .font(.body)
                            .foregroundColor(.secondary)

                        HStack {
                            Text("In Stock: \(availableStock)")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(availableStock > 0 ? Color("BrandGreen") : .red)

                            Spacer()

                            Button(action: {
                                if availableStock > 0 {
                                    globalStock[lunchMenuItem.name] = availableStock - 1
                                    cartItems[lunchMenuItem, default: 0] += 1
                                    addedItemName = lunchMenuItem.name
                                    showingAddedAlert = true
                                }
                            }) {
                                Text(availableStock <= 0 ? "Sold Out" : "Add to Cart")
                                    .font(.headline)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(availableStock <= 0 ? Color.gray : Color("BrandOrange"))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .disabled(availableStock <= 0)
                        }
                    }
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Weekly Schedule View
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Weekly Specials Schedule")
                            .font(.headline)
                            .foregroundColor(Color("BrandBlue"))
                            .padding(.horizontal)

                        let weeklyList = (selectedLocation == "Bruin Cafe TC") ? tcMenus : hqMenus

                        ForEach(weeklyList) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.day)
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(Color("BrandOrange"))
                                    Text(item.lunchTitle)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                }
                                Spacer()
                                Text(item.price)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(Color("BrandGreen"))
                            }
                            .padding(.vertical, 6)
                            Divider()
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
            }

            Spacer()

            // Universal Bottom Navigation Bar
            HStack(spacing: 8) {
                NavigationLink(destination: HomeView(
                    selectedLocation: $selectedLocation,
                    globalStock: $globalStock,
                    rewardPunches: $rewardPunches,
                    completedOrders: $completedOrders
                )) {
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

                NavigationLink(destination: OrderHistoryView(
                    selectedLocation: $selectedLocation,
                    cartItems: $cartItems,
                    globalStock: $globalStock,
                    rewardPunches: $rewardPunches,
                    completedOrders: $completedOrders
                )) {
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
        .navigationTitle("Lunch Menu")
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

struct LunchView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        @State var mockCart: [MenuItem: Int] = [:]
        @State var mockStock: [String: Int] = InventoryView.defaultInitialStock
        @State var mockPunches = 1
        @State var mockOrders: [PastOrder] = []
        var body: some View {
            NavigationStack {
                LunchView(
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