//
//  OpenMarketProductPatchParam.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/08.
//

import Foundation

struct OpenMarketProductPatchParam: Codable {
    var name: String
    var descriptions: String
    var price: Int
    var currency: OpenMarketProduct.Currency
    var discountedPrice: Float = 0.0
    var stock: Int = 0
    var secret: String
    var thumbnailId: Int
    
    enum CodingKeys: String, CodingKey {
        case name, descriptions, price, currency, stock, secret
        case discountedPrice = "discounted_price"
        case thumbnailId = "thumbnail_id"
    }
}
