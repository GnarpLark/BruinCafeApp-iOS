//
//  LocationView.swift
//  BruinCafeApp-iOS
//
//  Created by Student on 11/27/26.
//

import SwiftUI

struct LocationView: View {
    @Environment(CafeStore.self) private var store
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
            
            ForEach(store.staticValues.locations) { location in
                Button(action: {
                    let wasLocationNil = store.selectedLocation == nil
                    
                    store.selectedLocation = location
                    store.cart.removeAll() // GUARANTEED CART CLEARING
                        
                    print("Selected Location: \(store.selectedLocation?.displayName ?? "None")")
                    
                    if wasLocationNil {
                        print("Navigating to HomeView")
                        NavigationLink(destination: HomeView()) {}
                    } else {
                        print("Dismissing")
                        dismiss()
                    }
                }) {
                    VStack(spacing: 6) {
                        Text(location.displayName)
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("BrandBlue").opacity(0.8))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("LocationCardBackground"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("BrandBlue"), lineWidth: store.selectedLocation?.id == location.id ? 2 : 0)
                    )
                }
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

#Preview {
    LocationView()
}
