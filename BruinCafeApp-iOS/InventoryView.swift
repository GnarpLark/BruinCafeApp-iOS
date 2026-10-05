//
//  InventoryView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 9/30/26.
//

import SwiftUI

struct InventoryView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("App Content Goes Here")
            Spacer()
                Text("")
            }
            // 1. Adds the text title to the top bar
            .navigationTitle("Inventory")
            
            // 2. Adds buttons or custom views to the top bar
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("User: Staff") {
                        // Action
            
                    }
                
                    }
                }
            }
            
        }
    }

#Preview {
    InventoryView()
}
