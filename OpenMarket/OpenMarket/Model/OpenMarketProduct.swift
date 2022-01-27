//
//  OpenMarketProduct.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

struct OpenMarketProduct: Codable, Equatable {
    var id: Int?
    var vendorId: Int?
    var name: String?
    var thumbnailURLString: String?
    var currency: Currency?
    var price: Float?
    var description: String?
    var bargainPrice: Float?
    var discountedPrice: Float?
    var stock: Int?
    var createdAt: String?
    var issuedAt: String?
    var images: [ProductImage]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, currency, price, stock, images
        case vendorId = "vendor_id"
        case thumbnailURLString = "thumbnail"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
    
    enum Currency: String, Codable, Equatable {
        case krw = "KRW"
        case usd = "USD"
        
        func priceString(of price: Float) -> String {
            if self == .krw {
                return "\(self.rawValue) \(Int(price))"
            }
            return "\(self.rawValue) \(price)"
        }
    }
    
    struct ProductImage: Codable, Equatable {
        var id: Int?
        var urlString: String?
        var thumbnailURLString: String?
        var succeed: Bool?
        var issuedAt: String?
        
        enum CodingKeys: String, CodingKey {
            case id, succeed
            case urlString = "url"
            case thumbnailURLString = "thumbnail_url"
            case issuedAt = "issued_at"
        }
    }
}







