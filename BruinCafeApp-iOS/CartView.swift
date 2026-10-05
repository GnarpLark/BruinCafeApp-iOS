//
//  CartView.swift
//  
//
//  Created by Mack on 9/30/26.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        ZStack {
            VStack {
                NavigationStack {
                    VStack {
                        Text("Your Cart")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Order Summary")
                            .font(.title)
                            .fontWeight(.semibold)
                            .padding(.bottom, 100)
                            .padding(.top, 50)
                        // Clicking this button takes the user to menu (cant link that yet)
                        NavigationLink("Keep Browsing Menu", destination: OrderSimulationView())
                            .buttonStyle(.borderedProminent)

                    }
                    .navigationTitle("Order")

                    NavigationLink("Place Order", destination: OrderSimulationView())
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 50)

                                    
                }
                
            }
            .padding()
        }
    }
}

#Preview {
        CartView()
    }

