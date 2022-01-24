//
//  Item.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Item: Codable {
    let id: Int
    let venderId: Int
    let name: String
    let thumbnail: String
    private let currency_: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: Date
    let issuedAt: Date
    
    let description: String?
    let images: [Image]?
    let vendors: [Vendor]?
    
    var currency: Currency {
        Currency(rawValue: currency_) ?? .KRW
    }
    
    var thumbnailURL: URL? {
        URL(string: thumbnail)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, thumbnail, price, stock, description, images, vendors
        case venderId = "vendor_id"
        case currency_ = "currency"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
    
}
