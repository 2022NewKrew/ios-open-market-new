//
//  Vendor.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

struct Vendor: Codable {
    var name: String?
    var id: Int?
    var createdAt: String?
    var issuedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case name, id
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
