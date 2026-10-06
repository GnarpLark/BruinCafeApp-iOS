//
//  OrderSimulationView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 9/30/26.
//

import SwiftUI

struct OrderSimulationView: View {
    var body: some View {
        VStack {
            
            
            NavigationStack {
                VStack {
                    Text("Checkout")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Order Summary")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 100)
                        .padding(.top, 50)
                    // Clicking this button takes the user to CheckoutView (order confirmation page)
                    NavigationLink("Confirm Order", destination: CheckoutView())
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 50)
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
    OrderSimulationView()
}
