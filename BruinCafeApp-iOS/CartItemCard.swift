//
//  CartItemCard.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/1/26.
//

import SwiftUI

struct CartItemCard: View {
    let itemName: String
    let itemDescription: String
    let itemPrice: String
    let itemQuantity: Int
    let onAdd: () -> Void
    var onRemove: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Color.gray.opacity(0.3)
                Text("Img")
                    .font(.caption)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(itemName)
                    .font(.headline)
                    .foregroundColor(Color("BrandBlue"))
                Text(itemDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(itemPrice)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color("BrandGreen"))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("Qty: \(itemQuantity)")
                    .font(.subheadline)
                    .bold()

                HStack(spacing: 6) {
                    Button(action: onRemove) {
                        Text("-")
                            .font(.headline)
                            .bold()
                            .frame(width: 28, height: 28)
                            .background(Color.red.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }

                    Button(action: onAdd) {
                        Text("+")
                            .font(.headline)
                            .bold()
                            .frame(width: 28, height: 28)
                            .background(Color("BrandOrange"))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding()
        .background(Color("CardBackground"))
        .cornerRadius(12)
    }
}

#Preview {
    CartItemCard(itemName: "Pepperoni Roll", itemDescription: "Fresh baked roll", itemPrice: "$4.00", itemQuantity: 5, onAdd: {}, onRemove: {})
}
