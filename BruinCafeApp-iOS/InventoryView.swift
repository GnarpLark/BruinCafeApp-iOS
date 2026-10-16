//
//  InventoryView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 9/30/26.
//

import SwiftUI

struct InventoryView: View {
    @Binding var globalStock: [String: Int]
    @State private var showingAddAlert = false
    @State private var newName = ""
    @State private var newStock = ""
    @State private var selectedLocation = "Bruin Cafe HQ"
    @State private var showingLocationSheet = false
    @State private var dummyCart: [MenuItem: Int] = [:] // Renamed to dummyCart to prevent redeclaration conflicts

    var body: some View {
        VStack(spacing: 0) {
            // Staff Identification Bar with Location Button
            HStack {
                Text("Staff Identification Bar")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()

                Button(action: { showingLocationSheet = true }) {
                    Text("Location: \(selectedLocation)")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
            }
            .padding(10)
            .background(Color.black)
            .sheet(isPresented: $showingLocationSheet) {
                LocationView(selectedLocation: $selectedLocation, cartItems: $dummyCart)
            }

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Array(globalStock.keys.sorted()), id: \.self) { itemName in
                        HStack(spacing: 12) {
                            ZStack {
                                Color.gray.opacity(0.4)
                                Text("Img")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(Color("BrandBlue"))
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(6)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(itemName)
                                    .font(.headline)
                                    .foregroundColor(Color("BrandBlue"))
                                Text("Available Stock: \(globalStock[itemName] ?? 0)")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor((globalStock[itemName] ?? 0) > 0 ? Color("BrandGreen") : .red)
                            }

                            Spacer()

                            Button(action: {
                                globalStock[itemName, default: 0] += 5
                            }) {
                                Text("Restock (+5)")
                                    .font(.caption)
                                    .bold()
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(Color("BrandOrange"))
                                    .foregroundColor(.white)
                                    .cornerRadius(6)
                            }
                        }
                        .padding()
                        .background(Color("CardBackground"))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }

            HStack(spacing: 15) {
                Button(action: {
                    showingAddAlert = true
                }) {
                    Text("Add New Item")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color("BrandBlue"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.8))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .background(Color("AppBackground").ignoresSafeArea())
        .navigationTitle("Inventory Management")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Add New Stock Item", isPresented: $showingAddAlert) {
            TextField("Item Name", text: $newName)
            TextField("Initial Stock Quantity", text: $newStock)
            Button("Add") {
                let stock = Int(newStock) ?? 10
                if !newName.isEmpty {
                    globalStock[newName] = stock
                    newName = ""
                    newStock = ""
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
struct InventoryView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockStock: [String: Int] = ["HQ Signature Espresso": 12]
        var body: some View {
            NavigationStack {
                InventoryView(globalStock: $mockStock)
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
