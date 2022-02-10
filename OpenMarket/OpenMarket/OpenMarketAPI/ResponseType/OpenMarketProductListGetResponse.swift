//
//  OpenMarketAPIResponse.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

struct OpenMarketProudctListResponse: Decodable, Equatable {
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

