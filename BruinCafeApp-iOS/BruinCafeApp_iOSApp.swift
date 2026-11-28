//
//  BruinCafeApp_iOSApp.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/29/26.
//

import SwiftUI

@main
struct BruinCafeApp_iOSApp: App {
    
    @State private var store = CafeStore()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                // Start on ContentView/HomeView so the app opens to the home screen!
                ContentView()
            }
            .environment(store)
            .task {
                await store.refreshData()
            }
        }
    }
}
