//
//  OpenMarketUrl.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

import Foundation

enum OpenMarketURL {
    static let baseURL = "https://market-training.yagom-academy.kr/"
    case productList(pageNumber: Int, itemsPerPage: Int)
    case product(productId: Int)

    var url: URL? {
        switch self {
        case .productList(let pageNumber, let itemsPerPage):
            return URL(string: "\(OpenMarketURL.baseURL)/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)")
        case .product(let productId):
            return URL(string: "\(OpenMarketURL.baseURL)/api/products/\(productId)")
        }
    }
}
