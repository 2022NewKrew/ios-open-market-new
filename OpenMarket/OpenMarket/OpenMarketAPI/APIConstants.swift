//
//  APIConstants.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation


struct APIConstants {
    static let baseURL = "https://market-training.yagom-academy.kr/api/products"
    static let pageNo = "page_no"
    static let itemsPerPage = "items_per_page"
    static let productId = "product_id"
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
    case multiPartForm = "multipart/form-data; boundary=Boundary-"
}

enum HTTPMethod: String {
    case post = "POST"
    case `get` = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
}
