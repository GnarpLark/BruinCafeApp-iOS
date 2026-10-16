//
//  CartItemCard.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/1/26.
//

import SwiftUI

struct InventoryItemCard: View {
    let itemName: String
    let itemPrice: String
    @State var itemQuantity: Int
    @State var itemQuantityLabel: String
    
    
    var body: some View{
        HStack{
            Text(itemName)
                .padding(.horizontal)
            Text(itemPrice)
                .padding(.horizontal)
            Text("\(itemQuantity)")
                .padding(.horizontal)
            Button("Edit quantity", systemImage: "Amount \(itemQuantity)") {
                itemQuantity += 1
                
                if(itemQuantity <= 4) {
                    itemQuantityLabel = "Low Stock"
                }
                if(itemQuantity == 0) {
                    itemQuantityLabel = "Out of stock"
                }
                else {
                        itemQuantityLabel = "In Stock"
                    }
                // The action will be connected to cart state by the parent view.
                //If quantity is 5, default add is 1, but will need to remove 1 from the listed quantity
            }
            .padding()
            Spacer()
            

        }
        .background(RoundedRectangle(cornerRadius: 12))
        .foregroundStyle(Color.green)
        .opacity(0.50)
        .brightness(-0.5)
        
    }
    

    }

#Preview {
    InventoryItemCard(
        itemName: "Pepperoni Roll",
        itemPrice: "$3.50",
        itemQuantity: 5,
        itemQuantityLabel: "In Stock")
}
