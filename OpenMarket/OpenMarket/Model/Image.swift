//
//  Image.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Image: Decodable {
    let id: Int
    let url: String
    let thumbnailUrl: URL
    let succeed: Bool
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case thumbnailUrl = "thumbnail_url"
        case issuedAt = "issued_at"
        case id, url, succeed
    }
}
