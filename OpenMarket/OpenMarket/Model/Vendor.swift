//
//  Vendor.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Vendor: Codable {
    let name: String
    let id: Int
    let createdAt: Date
    let issuedAt: Date
    
    enum CodingKeys: String ,CodingKey {
        case name, id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
