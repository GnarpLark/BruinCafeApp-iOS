//
//  OrderHistory.swift
//  BruinCafeApp-iOS
//
//  Created by Mack on 10/15/26.
//

import Foundation

struct OrderLineItem: Codable, Identifiable {
    var id = UUID()
    let name: String
    let quantity: Int
    let price: Double

    var subtotal: Double {
        Double(quantity) * price
    }
}

struct OrderRecord: Codable, Identifiable {
    var id = UUID()
    let location: String
    let date: Date
    let items: [OrderLineItem]

    var total: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
}


struct OrderHistoryStore {
    private static var fileURL: URL {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0].appendingPathComponent("order_history.json")
    }

    static func loadOrders() -> [OrderRecord] {
        guard let data = try? Data(contentsOf: fileURL),
              let orders = try? JSONDecoder().decode(
                  [OrderRecord].self,
                  from: data
              ) else {
            return []
        }

        return orders
    }

    static func saveOrder(_ order: OrderRecord) throws {
        var orders = loadOrders()
        orders.append(order)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let data = try encoder.encode(orders)
        try data.write(to: fileURL, options: .atomic)
    }
}
