//
//  MenuItem.swift
//  BruinCafeApp-iOS
//
//  Created by David on 9/30/26.
//

import SwiftUI

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
    let price: String
    var stockQuantity: Int
}
