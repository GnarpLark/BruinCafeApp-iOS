//
//  CartView.swift
//  
//
//  Created by Mack on 9/30/26.
//

import SwiftUI

struct CartView: View {
    @State private var selectedLocation = "Bruin Cafe HQ"
    @State private var cartItems: [CartItem] = []

    var body: some View {
        NavigationStack {
        ZStack {
            Color(red: 0.96, green: 0.95, blue: 0.91)
                .ignoresSafeArea()
            VStack {

                        Text("Your Cart at \(selectedLocation)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Order Summary")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.bottom, 100)
                            .padding(.top, 50)
                        // Clicking this button takes the user to menu (cant link that yet)
                        NavigationLink("Keep Browsing Menu", destination: MenuView(selectedLocation: $selectedLocation))
                            .buttonStyle(.borderedProminent)

                    }
                    .navigationTitle("Order")

                    NavigationLink("Place Order", destination: OrderSimulationView(selectedLocation: $selectedLocation, cartItems: $cartItems))
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 50)

                                    
                }
                .background(Color(red: 0.96, green: 0.95, blue: 0.91)
                    .ignoresSafeArea())
            }
            .padding()
            .background(Color(red: 0.96, green: 0.95, blue: 0.91)
                .ignoresSafeArea())
        }
    }

#Preview {
    CartViewPreview(selectedLocation: "Bruin Cafe HQ", cartItems: [])
    }

private struct CartViewPreview: View {
    @State  var selectedLocation = "Bruin Cafe HQ"
    @State var cartItems: [CartItem] = []

    var body: some View {
        CartView()

    }
}
