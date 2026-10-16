//
//  HomeView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/30/26.
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedLocation: String
    
    @State private var cartItems: [MenuItem: Int] = [:]
    @State private var showingLocationSheet = false
    @State private var showingNewsAlert = false
    @State private var globalStock: [String: Int] = [
        "HQ Signature Espresso": 12,
        "Breakfast Burrito": 8,
        "Iced Caramel Macchiato": 6,
        "Tech Center Special Roast": 10,
        "Bruin Bagel": 5,
        "Energy Smoothie": 3,
        "Pumpkin Spice Harvest Latte": 15,
        "Maple Pecan Cranberry Muffin": 10,
        "Spiced Apple Cider Warm-Up": 12,
        "Turkey Cranberry Festive Panini": 8,
        "Hearty Beef Broth Bowl": 10,
        "Chicken Salad Wraps & Chips": 10,
        "Guinness Beef Stew": 10,
        "Crispy Fried Chicken Sandwich & Waffle Fries": 10,
        "Made-to-Order Flatbreads": 10,
        "BBQ Chicken with Mac & Cheese": 10,
        "Shrimp Fried Rice with Egg Roll": 10,
        "Pepperoni Pizza Flatbread": 10,
        "Beef Stroganoff over Egg Noodles": 10,
        "Hot Ham & Cheese with Potato Soup": 10
    ]

    var body: some View {
        VStack(spacing: 15) {
             
            // Header Bar & Logo
            HStack {
                Image("BruinCafeLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 38)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)

                Spacer()

                // Staff Login Button
                NavigationLink(destination: InventoryView(globalStock: $globalStock)) {
                    Text("Staff Login")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color("BrandBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }

                Button(action: { showingLocationSheet = true }) {
                    Text("Location")
                        .font(.headline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.gray)
                        .foregroundColor(Color("BrandBlue"))
                        .cornerRadius(6)
                }

                NavigationLink(destination: CartView(selectedLocation: $selectedLocation, cartItems: $cartItems, globalStock: $globalStock)) {
                    Text("Cart (\(cartItems.values.reduce(0, +)))")
                        .font(.headline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color("BrandOrange"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingLocationSheet) {
                LocationView(selectedLocation: $selectedLocation, cartItems: $cartItems)
            }

            Text("Active Location: \(selectedLocation)")
                .font(.subheadline)
                .bold()
                .foregroundColor(.secondary)

            // Rewards Card
            VStack(alignment: .leading, spacing: 8) {
                Text("Rewards")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))

                Text("1 / 10 Progression")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("RewardsTrackBackground"))
                            .frame(height: 20)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color("RewardsProgressFill"))
                            .frame(width: geo.size.width * 0.1, height: 20)
                    }
                }
                .frame(height: 20)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("LocationCardBackground"))
            .cornerRadius(12)
            .padding(.horizontal)

            // Menu Navigation Section Buttons
            NavigationLink(destination: LunchView(selectedLocation: $selectedLocation, cartItems: $cartItems, globalStock: $globalStock)) {
                VStack(spacing: 4) {
                    Text("Breakfast/Lunch")
                        .font(.title2)
                        .bold()
                    Text("Hours: 7:30AM - 2PM")
                        .font(.subheadline)
                }
                .foregroundColor(Color("BrandBlue"))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("LocationCardBackground"))
                .cornerRadius(12)
            }
            .padding(.horizontal)

            NavigationLink(destination: HolidayView(selectedLocation: $selectedLocation, cartItems: $cartItems, globalStock: $globalStock)) {
                Text("Holiday Specials")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("LocationCardBackground"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            NavigationLink(destination: MenuView(selectedLocation: $selectedLocation, cartItems: $cartItems, globalStock: $globalStock)) {
                Text("Cafe Items")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("LocationCardBackground"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()

            // Bottom Navigation Bar
            HStack(spacing: 8) {
                Button(action: {}) {
                    Text("Home")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color("BrandGreen"))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background(Color.gray)

                Button(action: {
                    showingNewsAlert = true
                }) {
                    Text("News")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color("BrandBlue"))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background(Color.gray)

                NavigationLink(destination: OrderHistoryView(selectedLocation: $selectedLocation, cartItems: $cartItems, globalStock: $globalStock)) {
                    Text("Order History")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color("BrandBlue"))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background(Color.gray)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .alert("News Unavailable", isPresented: $showingNewsAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The news page is currently unavailable.")
        }
    }
}

// MARK: - Preview Provider
struct HomeView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        var body: some View {
            NavigationStack {
                HomeView(selectedLocation: $mockLocation)
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
