//
//  StaffLoginView.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/9/26.
//

import SwiftUI
struct StaffLoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showInventory = false
    @Binding var selectedLocation: String

    
    var body: some View {
        @Previewable @State var location = "Bruin Cafe HQ"
        ZStack{
            Color(red: 0.96, green: 0.95, blue: 0.91)
                .ignoresSafeArea()
            VStack(spacing: 16){
                NavigationStack{
                    //heading 1
                    Text("Staff Login")
                        .font(.title2.bold())
                    //heading 2
                    Text("Enter Username (admin) \n   and Password (1234)")
                    
                    //username textfield
                    TextField("Enter Username", text: $username)
                        .padding(.top)
                        .padding( .bottom, 80)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.username)
                        .textFieldStyle(.roundedBorder)
                    //password text field
                    SecureField("Enter Password", text: $password)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .autocorrectionDisabled()
                        .textContentType(.password) // Enables Keychain/Autofill integration
                        .textFieldStyle(.roundedBorder)
                    //login button
                    Button("login") {
                        if username == "admin" && !password.isEmpty {
                            showInventory = true
                            
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(username.isEmpty || password.isEmpty)
                    .navigationDestination(isPresented: $showInventory) {
                        InventoryView(selectedLocation: $selectedLocation)
                    }
                    .onAppear { print("StaffLoginView appeared") }
                    .onChange(of: showInventory) { print("showInventory =", showInventory) }
                    
                }
                
            }
            
        }
    }
    
}


#Preview {
    StaffLoginPreview()
}

private struct StaffLoginPreview: View {
    @State private var selectedLocation = "Bruin Cafe HQ"

    var body: some View {
        StaffLoginView(selectedLocation: $selectedLocation)
    }
}
