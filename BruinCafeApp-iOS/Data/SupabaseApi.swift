//
//  SupabaseAPI.swift
//  BruinCafeApp-iOS
//
//  Created by Eli Feaster on 11/19/26.
//

import Foundation

actor SupabaseApi {
    private let timeout: TimeInterval = 8.0
    
    enum ApiError: Error {
        case invalidURL
        case requestFailed(Int, String)
        case decodingError(Error)
        case unknown
    }
    
    private func performRequest<T: Decodable>(
        path: String,
        method: String,
        body: String? = nil,
        extraHeaders: [String : String] = [:]
    ) async throws -> T {
        guard let url = URL(string: SupabaseConfig.url + "/rest/v1/" + path) else {
            throw ApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = timeout
        
        // Default Headers
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Customer Headers
        extraHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        if let body = body {
            request.httpBody = body.data(using: .utf8)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.unknown
        }
        
        if !(200...299).contains(httpResponse.statusCode) {
            let errorText = String(data: data, encoding: .utf8) ?? ""
            throw ApiError.requestFailed(httpResponse.statusCode, errorText)
        }
        
        if let decodedData = Data(base64Encoded: data.base64EncodedData()) {
            let decodedString = String(data: decodedData, encoding: .utf8)
            print(decodedString ?? "No data" as String)
        }
        
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date string does not match format HH:mm:ss")
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Failed at path: \(path)")
            throw ApiError.decodingError(error)
        }
    }
    
    // MARK: - API Methods
    
    func fetchLocations() async throws -> [CafeLocation] {
        return try await performRequest(path: "locations?select*&order=sort_order.asc", method: "GET")
    }
    
    func fetchMealPeriods() async throws -> [MealPeriodDef] {
        return try await performRequest(path: "meal_periods?select=*&order=start_time.asc", method: "GET")
    }
    
    func fetchMenuRows() async throws -> [MenuRow] {
        return try await performRequest(path: "menu_items?select=*&order=sort_order.asc", method: "GET")
    }
    
    func fetchSpecialItems() async throws -> [SpecialItem] {
        return try await performRequest(path: "special_items?select=*order=sort_order.asc", method: "GET")
    }
    
    func fetchInventory() async throws -> [InventoryRow] {
        return try await performRequest(path: "inventory?select=*", method: "GET")
    }
    
    func upsertInventoryQuantity(itemId: String, quantity: Int) async throws {
        let dict: [String : Any] = [
            "item_id": itemId,
            "quantity_on_hand": quantity
        ]
        
        let body = try JSONSerialization.data(withJSONObject: dict)
        let bodyString = String(data: body, encoding: .utf8)
        
        let headers = ["Prefer": "resolution=merge-duplicates,return=minimal"]
        
        let _: String = try await performRequest(
            path: "inventory?on_conflict=item_id",
            method: "POST",
            body: bodyString,
            extraHeaders: headers)
    }
}
