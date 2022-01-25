//
//  OpenMarketUrl.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

import Foundation

enum OpenMarketURL {
    static let baseURL = "https://market-training.yagom-academy.kr/"
    case productList(Int, Int)
    case product(Int)

    var url: URL? {
        switch self {
        case .productList(let pageNumber, let itemPerPage):
            return URL(string: "\(OpenMarketURL.baseURL)/api/products?page_no=\(pageNumber)&items_per_page=\(itemPerPage)")
        case .product(let productId):
            return URL(string: "\(OpenMarketURL.baseURL)/api/products/\(productId)")
        }
    }
}
