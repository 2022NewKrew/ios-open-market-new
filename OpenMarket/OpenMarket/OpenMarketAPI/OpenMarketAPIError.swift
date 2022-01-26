//
//  OpenMarketAPIError.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

enum OpenMarketAPIError: LocalizedError {
    case invalidRequest
    case notHTTPResponse
    case badRequest
    case serverError
    case noData
    case failDecoding
    case unknown
}
