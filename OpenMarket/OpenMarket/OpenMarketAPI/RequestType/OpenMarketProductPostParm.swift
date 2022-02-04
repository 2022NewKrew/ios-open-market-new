//
//  OpenMarketProductPostParm.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/03.
//

import Foundation

struct OpenMarketProductPostParam: Codable {
    var name: String
    var descriptions: String
    var price: Int
    var currency: OpenMarketProduct.Currency
    var discountedPrice: Int = 0
    var stock: Int = 0
    var secret: String
    
    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
    }
}
