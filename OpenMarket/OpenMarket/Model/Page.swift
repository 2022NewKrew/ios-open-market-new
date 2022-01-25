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
    let pages: [Product]
}
