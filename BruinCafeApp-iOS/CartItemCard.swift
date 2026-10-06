//
//  CartItemCard.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/1/26.
//

import SwiftUI

struct CartItemCard: View {
    let itemPic: String
    let itemName: String
    let itemDescription: String
    let itemQuantity: Int
    //let itemQuantityLabel: String?

    
    var body: some View{
        HStack{
            Image(systemName: itemPic)
                .font(.largeTitle)
                .frame(width: 50)
                .padding(.trailing, 10)
            Text(itemName)
            Text(itemDescription)
                .padding(.horizontal)
            Text("\(itemQuantity)")
                .padding(.horizontal)
            Button("Add to cart") {
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
    //if(itemQuantity <= 4) {
        //itemQuantityLabel = "Low Quantity"
    }

#Preview {
    CartItemCard(itemPic: "person.2.crop.square.stack.fill", itemName: "Pepperoni Roll", itemDescription: "Pepperoni Roll", itemQuantity: 5)
}
