//
//  OpenMarketProductPostResponse.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/03.
//

import Foundation

struct OpenMarketProudctPostResponse: Decodable, Equatable {
    var id: Int?
    var vendorId: Int?
    var vendorName: String?
    var description: String?
    var thumbnailImageUrl: String?
    var currency: OpenMarketProduct.Currency?
    var price: Int?
    var bargainPrcie: Int?
    var discountedPrice: Int?
    var stock: Int?
    var images: [OpenMarketProduct.ProductImage]?
    var vendor: Vendor?
    var createdAt: String?
    var issusedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, description, currency, price, stock, images
        case vendorId = "vendor_id"
        case vendorName = "name"
        case thumbnailImageUrl = "thumbnail"
        case bargainPrcie = "bargain_price"
        case discountedPrice = "discounted_price"
        case vendor = "vendors"
        case createdAt = "created_at"
        case issusedAt = "issued_at"
    }
}
