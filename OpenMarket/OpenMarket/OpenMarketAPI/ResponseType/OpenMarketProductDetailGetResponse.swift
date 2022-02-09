//
//  OpenMarketProductDetailGetResponse.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation
struct OpenMarketProductDetailGetResponse: Decodable {
    var id: Int?
    var vendorId: Int?
    var name: String?
    var description: String?
    var thumbnail: String?
    var currency: OpenMarketProduct.Currency?
    var price: Float?
    var bargainPrice: Float?
    var discountedPrice: Float?
    var stock: Int?
    var issuedAt: String?
    var createdAt: String?
    var images: [OpenMarketProduct.ProductImage]
    var vendors: Vendor
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail, currency, price, stock, images, vendors
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case issuedAt = "issued_at"
        case createdAt = "created_at"
    }
}
