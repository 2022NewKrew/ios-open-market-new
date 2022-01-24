//
//  ProductImage.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

struct ProductImage: Codable {
    let id: Int
    let url: String
    let thumbnailUrl: String
    let succeed: Bool
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
        case id, url, succeed
    }
}
