//
//  OpenMarketAPIResponse.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

struct GetOpenMarketProudctListResponse: Decodable {
    var pageNumber: Int?
    var itemsPerPage: Int?
    var totalCount: Int?
    var offset: Int?
    var limit: Int?
    var products: [OpenMarketProduct]?
    var lastPage: Int?
    var hasNext: Bool?
    var hasPrev: Bool?
    
    enum CodingKeys: String, CodingKey {
        case offset, limit
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case products = "pages"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}

struct GetDetailOpenMarketProductResponse: Decodable {
    var id: Int?
    var vendorId: Int?
    var name: String?
    var description: String?
    var thumbnail: String?
    var currency: String?
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


