//
//  Vendor.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

struct Vendor: Codable {
    let name: String
    let id: Int
    let createdAt: String
    let issuedAt: String

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case issuedAt = "issued_at"
        case name, id
    }
}
