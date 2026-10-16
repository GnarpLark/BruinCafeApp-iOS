//
//  CheckoutView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/2/26.
//

import SwiftUI



struct CheckoutView: View {
    @Binding var selectedLocation: String
    @Binding var cartItems: [CartItem]
    
    private let backgroundColor = Color(
        red: 0.96,
        green: 0.95,
        blue: 0.91
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                VStack {
                    // existing text and button
                    
                }
                .navigationTitle("Checkout")
                .toolbarBackground(
                    Color(red: 0.96, green: 0.95, blue: 0.91),
                    for: .navigationBar
                )
                .toolbarBackground(.visible, for: .navigationBar)
                
                VStack {
                    Text("\(selectedLocation) Order Confirmed!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 100)
                        .padding(.top, 50)
                    Text("This is a mock order simulation - \nsample  inventory has been\nupdated. You can pick up your order\nat \(selectedLocation)")
                        .padding(.bottom)
                    
                    // Clicking this button takes the user back to the location selection page, once I have that capability; change destination
                    NavigationLink("Start New Order", destination: LocationView(selectedLocation: $selectedLocation))
                        .buttonStyle(.borderedProminent)
                }
                .navigationTitle("Checkout")
                .background(Color(red: 0.96, green: 0.95, blue: 0.91).ignoresSafeArea())
            }
        }
    }
}



#Preview {
    CheckoutPreview(selectedLocation: "Bruin Cafe HQ", cartItems: [])
}

public struct CheckoutPreview: View {
    @State  var selectedLocation = "Bruin Cafe HQ"
    @State  var cartItems: [CartItem]

    public var body: some View {
        CheckoutView(selectedLocation: $selectedLocation, cartItems: $cartItems)
    }
}
