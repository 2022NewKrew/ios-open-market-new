//
//  Vendor.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Vendor: Decodable {
    let name: String
    let id: Int
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case name, id
    }
}
