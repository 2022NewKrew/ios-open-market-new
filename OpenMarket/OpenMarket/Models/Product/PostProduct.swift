//
//  PostProduct.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/09.
//

struct PostProduct: Codable {
    let name: String
    let descriptions: String
    let price: Double
    let currency: String
    let discountedPrice: Double
    let stock: Int
    let secret: String

    enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case name, descriptions, currency, price, stock, secret
    }
}
