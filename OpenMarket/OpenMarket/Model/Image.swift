//
//  Image.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Image: Codable {
    let id: Int
    let url: String
    let thumbnail: String
    let succeed: Bool
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, url, succeed
        case issuedAt = "issuedAt"
        case thumbnail = "thumbnailUrl"
    }
    
    var thumbnailUrl: URL? {
        URL(string: thumbnail)
    }
    
    var imageUrl: URL? {
        URL(string: url)
    }
}
