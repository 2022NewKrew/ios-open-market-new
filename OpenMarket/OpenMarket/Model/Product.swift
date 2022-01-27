//
//  Item.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Product: Codable, Hashable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    
    let description: String?
    let images: [Image]?
    let vendors: Vendor?
    var thumbnailURL: URL? {
        URL(string: thumbnail)
    }
}
