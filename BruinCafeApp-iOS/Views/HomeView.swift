//
//  HomeView.swift
//  BruinCafeApp-iOS
//
//  Created by David Crosen on 9/30/26.
//

import SwiftUI

struct HomeView: View {
    @Environment(CafeStore.self) private var store
    
    @State private var showingLocationSheet = false
    @State private var showingNewsAlert = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image("BruinCafeLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 38)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
                
                Spacer()
                
                /*// Staff Login Portal Button -> Navigates to StaffLoginView
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
                 }*/
                
                // Location Selector
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
                
                /*// Cart button displaying badge count
                 NavigationLink(destination)*/
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingLocationSheet) {
                LocationView()
            }
            
            // Active Location Display
            Text("Active Location: \(store.selectedLocation?.displayName ?? "[ERROR]")")
                .font(.subheadline)
                .bold()
                .foregroundColor(.secondary)
            
            VStack( alignment: .leading, spacing: 8) {
                HStack {
                    Text("Rewards")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("BrandBlue"))
                    
                    Spacer()
                    
                    // Free lunch status badge unlocked at 10 punches
                    if store.rewardPunches >= 10 {
                        Text("FREE LUNCH UNLOCKED")
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
                    Text("\(store.rewardPunches) / 10 Progression")
                        .font(.title)
                        .bold()
                        .foregroundColor(store.rewardPunches >= 10 ? Color("BrandGreen") : Color("BrandBlue"))
                    
                    Spacer()
                    
                    Text(store.rewardPunches >= 10 ? "Next order resets to 1 punch" : "\(10 - store.rewardPunches) more for free lunch")
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
                            .fill(store.rewardPunches >= 10 ? Color("BrandGreen") : Color("RewardsProgressFill"))
                            .frame(
                                width: max(0, min(geo.size.width * CGFloat(store.rewardPunches) / 10.0, geo.size.width)),
                                height: 20
                            )
                            .animation(.easeInOut(duration: 0.3), value: store.rewardPunches)
                    }
                }
                .frame(height: 20)
                
                Text(store.rewardPunches >= 10 ? "Congratulations! Enjoy your FREE lunch today. Next purchase will start a new rewards card." : "Earn 1 punch with every local purchase. Reach 10 punches for a free lunch!")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("CardBackground"))
            .cornerRadius(12)
            .padding(.horizontal)
            
            /*NavigationLink(destination: LunchView()) {
                VStack(spacing: 4) {
                    Text("Breakfast/Lunch")
                        .font(.title2)
                        .bold()
                    Text("Hours: 7:30AM - PM")
                        .font(.subheadline)
                }
                .foregroundColor(Color("BrandBlue"))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("CardBackground"))
                .cornerRadius(12)
            }
            .padding(.horizontal)*/
            
            /*NavigationLink(destination: HolidayView()) {
                Text("Holiday Specials")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)*/
            
            /*NavigationLink(desination: MenuView()) {
                Text("Cafe Items")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("CardBackground"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)*/
            
            Spacer()
            
            // Universal Botton Navigation Bar
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
                
                /*NavigationLink(destination: OrderHistoryView()) {
                    Text("Order History")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(.white))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background(Color.gray)*/
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationBarHidden(true)
        .alert("News", isPresented: $showingNewsAlert) {
            Button("Dismiss", role: .cancel) {}
        } message: {
            Text("News is currently unavailable.")
        }
    }
}

#Preview {
    HomeView()
}
