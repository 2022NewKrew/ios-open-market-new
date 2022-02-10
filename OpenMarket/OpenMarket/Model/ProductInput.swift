//
//  ProductInput.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/09.
//

import Foundation

struct ProductInput {
    let name: String
    let descriptions: String
    let price: Double
    let currency: Currency
    let discountedPrice: Double
    let stock: Int
}
