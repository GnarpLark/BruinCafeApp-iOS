//
//  BruinCafeApp_iOSApp.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/29/26.
//

import SwiftUI

@main
struct BruinCafeApp_iOSApp: App {
    
    @State private var selectedLocation: String = "Bruin Cafe HQ"

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                // Pass the binding down to the initial view
                LocationView(selectedLocation: $selectedLocation)
            }
        }
    }
}
