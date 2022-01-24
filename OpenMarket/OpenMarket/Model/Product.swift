//
//  Product.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    let images: [Image]?
    let vendors: Vendor?
    
    private enum CodingKeys: String, CodingKey {
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case id, name, thumbnail, currency, price, stock
        case images, vendors
    }
    
}
