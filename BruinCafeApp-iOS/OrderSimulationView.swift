//
//  OrderSimulationView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 10/15/26.
//

import SwiftUI

struct OrderSimulationView: View {
    @Binding var selectedLocation: String
    @Binding var cartItems: [MenuItem: Int]
    @Binding var globalStock: [String: Int]
    
    @State private var isConfirmed = false
    @State private var generatedOrderNumber = Int.random(in: 1000...9999)

    var body: some View {
        VStack(spacing: 15) {
            if !isConfirmed {
                Text("Checkout Review")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("BrandBlue"))
                    .padding(.top, 10)

                Text("Order Number: #\(generatedOrderNumber)")
                    .font(.headline)
                    .foregroundColor(.secondary)

                // Item #4 Note instruction
                Text("💡 Note: To remove an item or change quantities, please go back to your Cart.")
                    .font(.caption)
                    .bold()
                    .foregroundColor(Color("BrandOrange"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location: \(selectedLocation)")
                            .font(.headline)
                            .bold()
                            .foregroundColor(Color("BrandBlue"))

                        Divider()

                        Text("Items in Order:")
                            .font(.subheadline)
                            .bold()

                        ForEach(Array(cartItems.keys), id: \.id) { item in
                            HStack {
                                Text(item.name)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("x\(cartItems[item] ?? 0)")
                                    .font(.subheadline)
                                    .bold()
                                Text(item.price)
                                    .font(.subheadline)
                                    .foregroundColor(Color("BrandGreen"))
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("CardBackground"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                VStack(spacing: 12) {
                    Button(action: {
                        isConfirmed = true
                    }) {
                        Text("Confirm Order")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(cartItems.isEmpty ? Color.gray : Color("BrandOrange"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(cartItems.isEmpty)

                    NavigationLink(destination: CartView(selectedLocation: $selectedLocation, cartItems: $cartItems, globalStock: $globalStock)) {
                        Text("Back to Cart")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(Color("BrandBlue"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)

            } else {
                Spacer()

                Text("Order Confirmed!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("BrandGreen"))

                Text("Order Number: #\(generatedOrderNumber)")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("BrandBlue"))

                Text("This is a mock order simulation for \(selectedLocation).\nSample inventory has been updated.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()

                Spacer()

                NavigationLink(destination: HomeView(selectedLocation: $selectedLocation)) {
                    Text("Start New Order")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("BrandBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
                .simultaneousGesture(TapGesture().onEnded {
                    cartItems.removeAll()
                })
            }
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationTitle(isConfirmed ? "Confirmation" : "Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }
}
// MARK: - Preview Provider
struct OrderSimulationView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockLocation = "Bruin Cafe HQ"
        @State var mockCart: [MenuItem: Int] = [:]
        @State var mockStock: [String: Int] = [:]
        var body: some View {
            NavigationStack {
                OrderSimulationView(selectedLocation: $mockLocation, cartItems: $mockCart, globalStock: $mockStock)
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
