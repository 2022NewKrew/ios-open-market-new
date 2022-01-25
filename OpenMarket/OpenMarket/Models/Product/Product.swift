//
//  Product.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

struct Product: Codable {
    let id: Int
    let vendorId: Int
    let name: String
    let description: String?
    let thumbnail: String
    let currency: String
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let images: [ProductImage]?
    let vendors: Vendor?
    let createdAt: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case id, name, description, thumbnail, currency, price, stock, images, vendors
    }
}
