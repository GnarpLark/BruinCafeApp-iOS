//
//  LocationView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/30/26.
//

import SwiftUI

struct LocationView: View {
    @Binding var selectedLocation: String
    @Binding var cartItems: [MenuItem: Int] // Binding to cart items
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 25) {
            
            // Header Logo
            Image("BruinCafeLogo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 240, maxHeight: 90)
                .padding(.top, 10)

            Text("Choose a location:")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(white: 0.2))

            // MARK: - Location Option 1: HQ
            Button(action: {
                if selectedLocation != "Bruin Cafe HQ" {
                    selectedLocation = "Bruin Cafe HQ"
                    cartItems.removeAll() // GUARANTEED CART CLEARING
                }
                dismiss()
            }) {
                VStack(spacing: 6) {
                    Text("Bruin Cafe HQ")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color("BrandBlue"))
                    
                    Text("13650 Apple Harvest Dr, Martinsburg, WV 25403")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("BrandBlue").opacity(0.8))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("LocationCardBackground"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("BrandBlue"), lineWidth: selectedLocation == "Bruin Cafe HQ" ? 2 : 0)
                )
            }

            // MARK: - Location Option 2: TC
            Button(action: {
                if selectedLocation != "Bruin Cafe TC" {
                    selectedLocation = "Bruin Cafe TC"
                    cartItems.removeAll() // GUARANTEED CART CLEARING
                }
                dismiss()
            }) {
                VStack(spacing: 6) {
                    Text("Bruin Cafe TC")
                        .font(.title3)
                        .bold()
                        .foregroundColor(Color("BrandBlue"))
                    
                    Text("5550 Winchester Ave, Martinsburg, WV 25405")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("BrandBlue").opacity(0.8))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("LocationCardBackground"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("BrandBlue"), lineWidth: selectedLocation == "Bruin Cafe TC" ? 2 : 0)
                )
            }

            Spacer()

            // Footer Branding
            VStack(spacing: 6) {
                Text("Brought to you by")
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Image("BlueRidgeCTC")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        @State var mockCart: [MenuItem: Int] = [:]
        var body: some View {
            NavigationStack {
                LocationView(selectedLocation: $mockLocation, cartItems: $mockCart)
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
