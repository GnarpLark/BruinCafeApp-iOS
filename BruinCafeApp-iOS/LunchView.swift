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
    @State private var showingLocationSheet = false

    // Alert states
    @State private var showingAddedAlert = false
    @State private var addedItemName = ""
    @State private var showingNewsAlert = false

    var currentDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }

    let hqMenus = [
        DailyMenu(day: "Monday", lunchTitle: "Hearty Beef Broth Bowl", lunchDescription: "Savory beef broth filled with tender beef and hearty ingredients.", price: "$6.00"),
        DailyMenu(day: "Tuesday", lunchTitle: "Chicken Salad Wraps & Chips", lunchDescription: "Tender chicken in creamy dressing wrapped in a flour tortilla with chips.", price: "$6.50"),
        DailyMenu(day: "Wednesday", lunchTitle: "Guinness Beef Stew", lunchDescription: "Slow-simmered beef in rich Guinness stout gravy with vegetables.", price: "$7.00"),
        DailyMenu(day: "Thursday", lunchTitle: "Crispy Fried Chicken Sandwich & Waffle Fries", lunchDescription: "Golden crispy fried chicken on a toasted bun with waffle fries.", price: "$7.50"),
        DailyMenu(day: "Friday", lunchTitle: "Made-to-Order Flatbreads", lunchDescription: "Custom flatbread with fresh toppings, sauces, and melted cheeses.", price: "$8.00")
    ]

    let tcMenus = [
        DailyMenu(day: "Monday", lunchTitle: "BBQ Chicken with Mac & Cheese", lunchDescription: "Grilled chicken in smoky BBQ sauce with velvety mac & cheese and coleslaw.", price: "$7.00"),
        DailyMenu(day: "Tuesday", lunchTitle: "Shrimp Fried Rice with Egg Roll", lunchDescription: "Grilled shrimp over stir-fried rice with a vegetable egg roll.", price: "$7.50"),
        DailyMenu(day: "Wednesday", lunchTitle: "Pepperoni Pizza Flatbread", lunchDescription: "Flatbread filled with pepperoni and mozzarella with garlic butter.", price: "$6.50"),
        DailyMenu(day: "Thursday", lunchTitle: "Beef Stroganoff over Egg Noodles", lunchDescription: "Beef with onions and mushrooms in a rich sour cream mushroom sauce.", price: "$7.25"),
        DailyMenu(day: "Friday", lunchTitle: "Hot Ham & Cheese with Potato Soup", lunchDescription: "Sliced ham and cheddar on a croissant with warm potato soup.", price: "$6.75")
    ]

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
                VStack(spacing: 20) {
                    VStack(spacing: 4) {
                        Text("\(selectedLocation) Today's Lunch")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color("BrandBlue"))
                        Text("Today is \(currentDayString)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Featured Lunch Item")
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color("BrandOrange"))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(todayMenu.day + " - " + todayMenu.lunchTitle)
                                .font(.headline)
                                .foregroundColor(Color("BrandBlue"))
                            Text(todayMenu.lunchDescription)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(todayMenu.price)
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(Color("BrandGreen"))
                                    Text("In Stock: \(availableStock)")
                                        .font(.footnote)
                                        .bold()
                                        .foregroundColor(availableStock > 0 ? Color("BrandGreen") : .red)
                                }
                                
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
                                        .font(.caption)
                                        .bold()
                                        .padding(8)
                                        .background(availableStock <= 0 ? Color.gray : Color("BrandOrange"))
                                        .foregroundColor(.white)
                                        .cornerRadius(6)
                                }
                                .disabled(availableStock <= 0)
                            }
                        }
                        .padding()
                        .background(Color("CardBackground"))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
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
        @State var mockStock: [String: Int] = ["Hearty Beef Broth Bowl": 10]
        var body: some View {
            NavigationStack {
                LunchView(selectedLocation: $mockLocation, cartItems: $mockCart, globalStock: $mockStock)
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
