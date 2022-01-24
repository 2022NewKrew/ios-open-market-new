//
//  Page.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Page: Codable{
    let pageNo: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    let pages: [Item]
    
    enum CodingKeys: String,CodingKey {
        case offset, limit, pages
        case pageNo = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
    
}
