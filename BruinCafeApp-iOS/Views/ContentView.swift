//
//  ContentView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/30/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(CafeStore.self) private var store
    
    var body: some View {
        if store.isLoading {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            ProgressView("Loading...")
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        
        if !store.isLoading && store.isLoadedSuccesfully {
            //print("The order data was loaded successfully!")
            NavigationStack {
                LocationView()
            }
        } else {
            VStack {
                Text("There was an issue loading the order data. Please try again.")
                Button("Exit App") {
                    exit(0)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
