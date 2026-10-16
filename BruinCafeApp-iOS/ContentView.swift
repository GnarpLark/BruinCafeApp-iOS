//
//  ContentView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedLocation: String = "Bruin Cafe HQ"

    var body: some View {
        NavigationStack {
            HomeView(selectedLocation: $selectedLocation)
        }
    }
}

#Preview {
    ContentView()
}
