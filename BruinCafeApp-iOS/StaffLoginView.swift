//
//  StaffLoginView.swift
//  BruinCafeApp-iOS
//
//  Created by David on 11/13/26.
//

import SwiftUI

/// Mock Staff Login Portal View
///
/// Provides a mock credentials check for cafe staff to access the live inventory management portal.
/// - Valid Credentials: Username "Admin" (case-insensitive) and PIN "1234".
/// - Features an on-screen hint card with a 1-tap Auto-fill button for fast testing.
/// - Passes `$globalStock` and `$selectedLocation` to `InventoryView` for synchronized stock adjustments.
struct StaffLoginView: View {
    // MARK: - Bindings
    /// Shared global inventory dictionary tracked across all menus and staff screens.
    @Binding var globalStock: [String: Int]
    /// Active cafe location ("Bruin Cafe HQ" or "Bruin Cafe TC") passed into the inventory portal.
    @Binding var selectedLocation: String

    // MARK: - State Properties
    /// Input username (tested against "Admin").
    @State private var username = ""
    /// Input PIN or password (tested against "1234").
    @State private var pinCode = ""
    /// Controls navigation to `InventoryView` upon successful authentication.
    @State private var isAuthenticated = false
    /// Controls presentation of the invalid credentials error banner.
    @State private var showingError = false

    // MARK: - Initializer
    init(
        globalStock: Binding<[String: Int]>,
        selectedLocation: Binding<String> = .constant("Bruin Cafe HQ")
    ) {
        self._globalStock = globalStock
        self._selectedLocation = selectedLocation
    }

    // MARK: - View Body
    var body: some View {
        VStack(spacing: 20) {
            // App Branding Logo
            Image("BruinCafeLogo")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 70)
                .padding(.top, 10)

            Text("Staff Portal Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("BrandBlue"))

            // MARK: Testing Credentials Hint Card
            // Prominently displays the required test credentials with a convenient 1-tap Auto-fill button.
            HStack(spacing: 12) {
                Image(systemName: "key.fill")
                    .foregroundColor(Color("BrandOrange"))
                    .font(.title3)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Testing Credentials")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color("BrandBlue"))
                    Text("Username: Admin  •  PIN: 1234")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Auto-fill Action
                Button(action: {
                    username = "Admin"
                    pinCode = "1234"
                    showingError = false
                }) {
                    Text("Auto-fill")
                        .font(.caption)
                        .bold()
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color("BrandBlue").opacity(0.12))
                        .foregroundColor(Color("BrandBlue"))
                        .cornerRadius(6)
                }
            }
            .padding(12)
            .background(Color("CardBackground"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BrandBlue").opacity(0.25), lineWidth: 1)
            )
            .padding(.horizontal, 30)

            // MARK: Credential Input Fields
            VStack(spacing: 12) {
                // Username Field
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("BrandBlue"))
                        .frame(width: 24)
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
                .padding()
                .background(Color("CardBackground"))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))

                // PIN / Password Secure Field
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color("BrandBlue"))
                        .frame(width: 24)
                    SecureField("PIN / Password", text: $pinCode)
                        .keyboardType(.numberPad)
                }
                .padding()
                .background(Color("CardBackground"))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
            }
            .padding(.horizontal, 30)

            // MARK: Error Message Banner
            if showingError {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Invalid credentials. Try Admin / 1234.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .bold()
                }
            }

            // MARK: Login Submission Button
            Button(action: {
                let trimmedUser = username.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedPin = pinCode.trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Verify credentials against mock Admin / 1234
                if trimmedUser.caseInsensitiveCompare("Admin") == .orderedSame && trimmedPin == "1234" {
                    showingError = false
                    isAuthenticated = true
                } else {
                    showingError = true
                }
            }) {
                Text("Login")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("BrandBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 30)

            Spacer()
        }
        .padding()
        .background(Color("AppBackground").ignoresSafeArea())
        // Navigate directly to InventoryView upon successful credential check
        .navigationDestination(isPresented: $isAuthenticated) {
            InventoryView(globalStock: $globalStock, selectedLocation: $selectedLocation)
        }
        .navigationTitle("Staff Login")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview Provider
struct StaffLoginView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var mockStock: [String: Int] = InventoryView.defaultInitialStock
        @State var mockLocation = "Bruin Cafe HQ"
        var body: some View {
            NavigationStack {
                StaffLoginView(globalStock: $mockStock, selectedLocation: $mockLocation)
            }
        }
    }
    static var previews: some View {
        PreviewWrapper()
    }
}
