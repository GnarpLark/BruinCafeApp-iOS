//
//  SupabaseAPI.swift
//  BruinCafeApp-iOS
//
//  Created by Eli Feaster on 11/19/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL, requestFailed, decodingError
}

class SupabaseService {
    private let baseURL = SupabaseConfig.url + "/rest/v1"
    
    // MARK: - Request Helper
    private func performRequest<T: Decodable>(
        path: String,
        method: String,
        body: String? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let body = body {
            request.httpBody = body.data(using: .utf8)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - API Methods

    func fetchMenu() async throws -> [MenuItem] {
        try await performRequest(path: "menu_items?select=*", method: "GET")
    }
    
    func fetchInventory() async throws -> [InventoryItem] {
        try await performRequest(path: "inventory?select=*", method: "GET")
    }
    
    func fetchSpecialItems() async throws -> [Specialitem] {
        try await performRequest(path: "special_items?select=*", method: "GET")
    }
    
    func upsertInventory(itemId: String, quantity: Int) async throws {
        let body = "{\"item_id\": \"\(itemId)\", \"quantity_on_hand\": \(quantity)}"
        let toDiscard: MenuItem? = try await performRequest(path: "inventory?on_conflict=item_id", method: "POST", body: body)
    }
}

/*
enum SupabaseError: Error {
    case invalidURL
    case requestFailed(String)
    case decodingError
}

class SupabaseAPI {
    
    private let baseURL = SupabaseConfig.url + "/rest/v1"
    
    // Reusable, generic URL request method
    private func performRequest<T: Decodable>(
        path: String,
        method: String,
        body: Data? = nil,
        extraHeaders: [String: String] = [:]
    ) async throws -> T {
        
        guard let url = URL(string: baseURL + path) else {
            throw SupabaseError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Apply extra headers (such as "Prefer" or "Content-Type")
        extraHeaders.forEach( { request.setValue($1, forHTTPHeaderField: $0) } )
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SupabaseError.requestFailed("Not an HTTP response")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Unknown Error"
            throw SupabaseError.requestFailed("HTTP \(httpResponse.statusCode): \(errorMsg)")
        }
        
        let decoder = JSONDecoder()
        
        // Custom Date Decoder for 00:00:00 format
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm:ss"
        timeFormater.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(timeFormater)
        
        return try decoder.decode(T.self, from: data)
    }
    
    func fetchLocations() async throws -> [CafeLocation]
}
*/
