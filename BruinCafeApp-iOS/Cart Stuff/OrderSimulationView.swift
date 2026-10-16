//
//  OrderSimulationView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 9/30/26.
//

import SwiftUI

struct OrderSimulationView: View {
    @Binding var selectedLocation: String
    @Binding var cartItems: [CartItem]
    
    var body: some View {
    NavigationStack {
        ZStack{
            // Background color fills the entire screen
            Color(red: 0.96, green: 0.95, blue: 0.91)
                .ignoresSafeArea()
            
                VStack {
                    Text("Checkout")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Order Summary")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 100)
                        .padding(.top, 50)
                    ForEach(cartItems) { item in
                        Text("\(item.itemName) × \(item.itemQuantity)")
                    }
                    // Clicking this button takes the user to CheckoutView (order confirmation page)
                    NavigationLink("Confirm Order", destination: CheckoutView(selectedLocation: $selectedLocation, cartItems: $cartItems))
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 50)
                    //Cart
                    NavigationLink("Back to Cart", destination: CartView())
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 50)
                }
                .navigationTitle("Order")
                
                
            }
        }
    }
}

#Preview {
    OrderSimulationPreview(       selectedLocation: "Bruin Cafe HQ",
                           cartItems: .constant([]))
}

private struct OrderSimulationPreview: View {
    @State  var selectedLocation = "Bruin Cafe HQ"
    @Binding var cartItems: [CartItem]

    var body: some View {
        OrderSimulationView(selectedLocation: $selectedLocation, cartItems: $cartItems)

    }
}
