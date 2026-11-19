//
//  ContentView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/30/26.
//

import SwiftUI

/// App Root View
///
/// Holds the primary `@State` properties for the application and injects persistent
/// initial states from `OrderStore` (reward punches and order history) into `HomeView`.
struct ContentView: View {
    // MARK: - Root State Properties
    /// Currently selected campus cafe location (defaults to HQ).
    @State private var selectedLocation: String = "Bruin Cafe HQ"
    
    /// Global inventory stock counts across all locations, initialized from the central definition in `InventoryView`.
    //@State private var globalStock: [String: Int] = InventoryView.defaultInitialStock
    
    /// User's current loyalty punch card progress, restored from persistent storage.
    @State private var rewardPunches: Int = OrderStore.shared.loadPunches()
    
    /// Stored history of completed transactions, restored from local storage.
    @State private var completedOrders: [PastOrder] = OrderStore.shared.loadOrders()
    
    @State private var invStore: InventoryStore = InventoryStore()
    // MARK: - View Body
    var body: some View {
        NavigationStack {
            HomeView(invStore: invStore, rewardPunches: $rewardPunches, completedOrders: $completedOrders)
        }
        .task {
            // Load data when the app opens
            await invStore.refreshData()
        }
    }
}

// MARK: - Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
