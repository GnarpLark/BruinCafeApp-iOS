//
//  CheckoutView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/2/26.
//

import SwiftUI

struct CheckoutView: View {
    var body: some View {
        VStack {

        NavigationStack {
            VStack {
                Text("Order Confirmed!")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.bottom, 100)
                    .padding(.top, 50)
                Text("This is a mock order simulation - \nsample  inventory has been\n updated")
                    .padding(.bottom)
                    

                // Clicking this button takes the user back to the location selection page, once I have that capability; change destination
                NavigationLink("Start New Order", destination: OrderSimulationView())
                    .buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("Checkout")
            
        }
    }
    }
}

#Preview {
    CheckoutView()
}
