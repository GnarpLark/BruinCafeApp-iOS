//
//  MenuView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/30/26.
//

import SwiftUI

// MARK: - Menu Item Model
struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let price: String
}

// MARK: - Menu View
struct MenuView: View {
    @Binding var selectedLocation: String
    // Receives binding from HomeView
    
    // Internal state for re-opening LocationView if needed (optional, but helpful)
    @State private var showingLocationSheet = false
    
    // MARK: - Data Source Logic
    /// Dynamically returns different items based on which cafe location is actively selected.
    var menuItems: [MenuItem] {
        if selectedLocation == "Bruin Cafe TC" {
            return [
                MenuItem(name: "Tech Center Special Roast", description: "Fresh drip coffee with caramel", price: "$3.50"),
                MenuItem(name: "Bruin Bagel", description: "Everything bagel with cream cheese", price: "$4.00"),
                MenuItem(name: "Energy Smoothie", description: "Strawberry banana protein blend", price: "$5.50")
            ]
        } else {
            return [
                MenuItem(name: "HQ Signature Espresso", description: "Double shot dark roast espresso", price: "$3.00"),
                MenuItem(name: "Breakfast Burrito", description: "Eggs, bacon, cheddar, salsa", price: "$6.50"),
                MenuItem(name: "Iced Caramel Macchiato", description: "Espresso with vanilla and caramel", price: "$4.75")
            ]
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            
            // Top Navigation Bar
            HStack {
                // Button to change location via sheet (safer than NavigationLink in a menu)
                Button(action: {
                    showingLocationSheet = true
                }) {
                    Text("Location")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray)
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
                 
                Spacer()
                 
                // Shopping Cart Button
                Button(action: {}) {
                    Text("Cart")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.gray)
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            
            .sheet(isPresented:
                    $showingLocationSheet) {
                // Pass the REAL binding location so it can be updated again from the sheet
                LocationView(selectedLocation: $selectedLocation)
            }

            // Header Title
            Text("\(selectedLocation) Menu")
                .font(.title2)
                .bold()
                .padding(.top, 5)

            // Scrollable Menu List
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(menuItems) { item in
                        HStack {
                            // Item Thumbnail Placeholder
                            ZStack {
                                Color.gray
                                Text("Image")
                                    .foregroundColor(.purple)
                                    .bold()
                            }
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)

                            // Item Description
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Text(item.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(item.price)
                                    .font(.subheadline)
                                    .bold()
                            }

                            Spacer()

                            // Add to Cart Button
                            Button(action: {}) {
                                Text("Add to Cart")
                                    .font(.caption)
                                    .bold()
                                    .padding(8)
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }
                        }
                        .padding()
                        .background(Color(red: 0.85, green: 0.95, blue: 0.88))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }

            Spacer()

            // Bottom Navigation Bar
            HStack(spacing: 8) {
                NavigationLink(destination: HomeView(selectedLocation: $selectedLocation)) {
                    Text("Main")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.green)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray)
                }

                Button(action: {}) {
                    Text("News")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.blue)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray)
                }

                Button(action: {}) {
                    Text("Order History")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.blue)
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
        .background(Color(red: 0.96, green: 0.95, blue: 0.91).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview Provider
struct MenuView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        var body: some View {
            NavigationStack {
                MenuView(selectedLocation: $mockLocation)
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
