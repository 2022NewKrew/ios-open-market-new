//
//  ProductImage.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

import Foundation

struct ProductImage: Codable {
    let id: Int
    let url: String
    let thumbnailUrlString: String
    let succeed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case thumbnailUrlString = "thumbnail_url"
        case issuedAt = "issued_at"
        case id, url, succeed
    }
}
