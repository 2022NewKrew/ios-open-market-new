//
//  HTTPMethod.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

enum HTTPMethod {
    case get
    case post
    case patch
    case delete

    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
