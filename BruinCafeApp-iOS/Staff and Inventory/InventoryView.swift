//
//  InventoryView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 9/30/26.
//

import SwiftUI

struct InventoryView: View {
    @Binding var selectedLocation: String
    let inventory = Inventory()


    let locations = {
        "Bruin Cafe HQ"
        "Bruin Cafe TC"
    }

    var body: some View {


            VStack {
                NavigationStack {

                ForEach(inventory.items(selectedLocation: selectedLocation)) { item in
                    InventoryItemCard(
                        itemName: item.name,
                        itemPrice: item.price,
                        itemQuantity: item.quantity,
                        itemQuantityLabel: item.quantityLabel)
                }
                .padding()
                    //Button to update inventory
                    Button("Update Inventory") {
                        //add functionality
                    }
            }
            .background(Color(red: 0.96, green: 0.95, blue: 0.91).ignoresSafeArea())
            // 1. Adds the text title to the top bar
            .navigationTitle("Inventory")
            Spacer()

            
            // 2. Adds buttons or custom views to the top bar
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("User: Staff") {
                            // Add staff-related action here
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            LocationView(
                                selectedLocation: $selectedLocation
                            )
                        } label: {
                            HStack {
                                Text(selectedLocation)
                                Image(systemName: "chevron.down")
                            }
                        }
                    }


                }


    }
            .background(Color(red: 0.96, green: 0.95, blue: 0.91).ignoresSafeArea())


    }

}

// MARK: - Preview Provider
struct InventoryView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        var body: some View {
            NavigationStack {
                InventoryView(selectedLocation: $mockLocation)
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
