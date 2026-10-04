//
//  HomeView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/30/26.
//

import SwiftUI

// MARK: - Home View
struct HomeView: View {
    @Binding var selectedLocation: String // Receives binding from LocationView

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

                // Location Page Navigation Link Pass binding with $
                NavigationLink(destination: LocationView(selectedLocation: $selectedLocation)) {
                    Text("Location")
                        .font(.headline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.gray)
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                }

                // Cart Button Placeholder
                Button(action: {}) {
                    Text("Cart")
                        .font(.headline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.gray)
                        .foregroundColor(.blue)
                        .cornerRadius(6)
                }
            }
            .padding(.horizontal)

            // Current Location Indicator
            Text("Active Location: \(selectedLocation)")
                .font(.subheadline)
                .bold()
                .foregroundColor(.secondary)

            // Rewards Card
            VStack(alignment: .leading, spacing: 8) {
                Text("Rewards")
                    .font(.title)
                    .bold()
                    .foregroundColor(.blue)

                Text("1 / 10 Progression")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.orange.opacity(0.8))
                            .frame(height: 20)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.purple)
                            .frame(width: geo.size.width * 0.1, height: 20)
                    }
                }
                .frame(height: 20)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.75, green: 0.95, blue: 0.85))
            .cornerRadius(12)
            .padding(.horizontal)

            // Menu Navigation Section Buttons
            
            // 1. Breakfast/Lunch (Placeholder)
            Button(action: { /* TODO */ }) {
                VStack(spacing: 4) {
                    Text("Breakfast/Lunch")
                        .font(.title2)
                        .bold()
                    Text("Hours: 7AM - 3PM")
                        .font(.subheadline)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.75, green: 0.95, blue: 0.85))
                .cornerRadius(12)
            }
            .padding(.horizontal)

            // 2. Weekly Specials (Placeholder)
            Button(action: { /* TODO */ }) {
                Text("Weekly Specials")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.75, green: 0.95, blue: 0.85))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            // 3. Cafe Items -> Navigates to MenuView
            // Pass binding with $
            NavigationLink(destination: MenuView(selectedLocation: $selectedLocation)) {
                Text("Cafe Items")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0.75, green: 0.95, blue: 0.85))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()

            // Bottom Navigation Bar
            HStack(spacing: 8) {
                Button(action: {}) {
                    Text("Main")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.green)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background(Color.gray)

                Button(action: {}) {
                    Text("News")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.blue)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .background(Color.gray)

                Button(action: {}) {
                    Text("Order History")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.blue)
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
        .background(Color(red: 0.96, green: 0.95, blue: 0.91).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
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
