//  HomeView.swift
//  BruinCafeApp-iOS

import SwiftUI

/// Main Home Dashboard View
///
/// Serves as the landing hub of the Bruin Cafe customer application.
///
/// Features:
/// - Displays the dynamic Rewards punch card progress bar (`rewardPunches / 10.0`), free lunch status banner, and countdown text.
/// - Shows active location indicator.
/// - Provides access to Staff Login, Location selector, Cart, Breakfast/Lunch menu, Holiday specials, and Cafe items.
/// - Synchronizes shared bindings for `globalStock`, `rewardPunches`, and `completedOrders`.
struct HomeView: View {
    // MARK: - Bindings
    /// Active cafe location ("Bruin Cafe HQ" or "Bruin Cafe TC").
    @Binding var selectedLocation: String
    /// Central shared inventory stock dictionary.
    @Binding var globalStock: [String: Int]
    /// Customer punch card count (1...10).
    @Binding var rewardPunches: Int
    /// Array of locally completed orders.
    @Binding var completedOrders: [PastOrder]

    // MARK: - Initializer with Default Fallbacks
    init(
        selectedLocation: Binding<String> = "Bruin Cafe HQ",
        globalStock: Binding<[String: Int]> = .constant(InventoryView.defaultInitialStock),
        rewardPunches: Binding<Int> = .constant(1),
        completedOrders: Binding<[PastOrder]> = .constant([])
    ) {
        self._selectedLocation = selectedLocation
        self._globalStock = globalStock
        self._rewardPunches = rewardPunches
        self._completedOrders = completedOrders
    }
    
    // MARK: - State Properties
    @State private var cartItems: [MenuItem: Int] = [:]
    @State private var showingLocationSheet = false
    @State private var showingNewsAlert = false

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 15) {
             
            // MARK: Top Navigation & Header Bar
            HStack {
                Image("BruinCafeLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 38)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)

                Spacer()

                // Staff Login Portal Button -> Navigates to StaffLoginView
                NavigationLink(destination: StaffLoginView(globalStock: $globalStock, selectedLocation: $selectedLocation)) {
                    Text("Staff Login")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 11)
                        .background(Color("BrandBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }

                // Modal Location Selector
                Button(action: { showingLocationSheet = true }) {
                    Text("Location")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 11)
                        .background(Color.gray)
                        .foregroundColor(Color(.white))
                        .cornerRadius(6)
                }

                // Cart Button displaying badge count
                NavigationLink(destination: CartView(
                    selectedLocation: $selectedLocation,
                    cartItems: $cartItems,
                    globalStock: $globalStock,
                    rewardPunches: $rewardPunches,
                    completedOrders: $completedOrders
                )) {
                    Text("Cart (\(cartItems.values.reduce(0, +)))")
                        .font(.headline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color("BrandRed"))
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingLocationSheet) {
                LocationView(selectedLocation: $selectedLocation, cartItems: $cartItems)
            }

            // Active Location Display
            Text("Active Location: \(selectedLocation)")
                .font(.subheadline)
                .bold()
                .foregroundColor(.secondary)

            // MARK: Dynamic Rewards Progress Card
            // Counts 1 punch per purchase out of 10 before free lunch, resetting after 10 punches.
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Rewards")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("BrandBlue"))
                    
                    Spacer()

                    // Free lunch status badge unlocked at 10 punches
                    if rewardPunches >= 10 {
                        Text("FREE LUNCH UNLOCKED!")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color("BrandGreen"))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }

                HStack {
                    Text("\(rewardPunches) / 10 Progression")
                        .font(.title3)
                        .bold()
                        .foregroundColor(rewardPunches >= 10 ? Color("BrandGreen") : Color("BrandBlue"))
                    
                    Spacer()
                    
                    Text(rewardPunches >= 10 ? "Next order resets to 1 punch" : "\(10 - rewardPunches) more for free lunch")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.secondary)
                }

                // Animated Progress Bar Fill
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        // Background Track
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color("RewardsTrackBackground"))
                            .frame(height: 20)
                        
                        // Active Progress Fill
                        RoundedRectangle(cornerRadius: 6)
                            .fill(rewardPunches >= 10 ? Color("BrandGreen") : Color("RewardsProgressFill"))
                            .frame(
                                width: max(0, min(geo.size.width * CGFloat(rewardPunches) / 10.0, geo.size.width)),
                                height: 20
                            )
                            .animation(.easeInOut(duration: 0.3), value: rewardPunches)
                    }
                }
                .frame(height: 20)

                Text(rewardPunches >= 10 ? "Congratulations! Enjoy your FREE lunch today. Next purchase will start a new rewards card." : "Earn 1 punch with every local purchase. Reach 10 punches for a free lunch!")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("CardBackground"))
            .cornerRadius(12)
            .padding(.horizontal)

            // MARK: Menu Category Navigation Cards
            // 1. Breakfast / Lunch Daily Specials
            NavigationLink(destination: LunchView(
                selectedLocation: $selectedLocation,
                cartItems: $cartItems,
                globalStock: $globalStock,
                rewardPunches: $rewardPunches,
                completedOrders: $completedOrders
            )) {
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
                .background(Color("CardBackground"))
                .cornerRadius(12)
            }
            .padding(.horizontal)

            // 2. Holiday Seasonal Specials
            NavigationLink(destination: HolidayView(
                selectedLocation: $selectedLocation,
                cartItems: $cartItems,
                globalStock: $globalStock,
                rewardPunches: $rewardPunches,
                completedOrders: $completedOrders
            )) {
                Text("Holiday Specials")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            // 3. Standard Cafe Items
            NavigationLink(destination: MenuView(
                selectedLocation: $selectedLocation,
                cartItems: $cartItems,
                globalStock: $globalStock,
                rewardPunches: $rewardPunches,
                completedOrders: $completedOrders
            )) {
                Text("Cafe Items")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()

            // MARK: Universal Bottom Navigation Bar
            HStack(spacing: 8) {
                Button(action: {}) {
                    Text("Home")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(.black))
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
                        .foregroundColor(Color(.white))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background(Color.gray)
                
                NavigationLink(destination: OrderHistoryView(
                    selectedLocation: $selectedLocation,
                    cartItems: $cartItems,
                    globalStock: $globalStock,
                    rewardPunches: $rewardPunches,
                    completedOrders: $completedOrders
                )) {
                    Text("Order History")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(.white))
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
        .navigationBarHidden(true)
        .alert("News", isPresented: $showingNewsAlert) {
            Button("Dismiss", role: .cancel) { }
        } message: {
            Text("News is currently unavailable")
        }
    }
}

// MARK: - Preview Provider
struct HomeView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        @State var mockStock = InventoryView.defaultInitialStock
        @State var mockPunches = 1
        @State var mockOrders: [PastOrder] = []
        
        var body: some View {
            NavigationStack {
                HomeView(
                    selectedLocation: $mockLocation,
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
