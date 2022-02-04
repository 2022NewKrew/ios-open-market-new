//
//  ProductList.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

struct ProductList: Decodable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    var products: [Product]?

    enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
        case products = "pages"
        case offset, limit
    }
}
