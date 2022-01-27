//
//  ProductListCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/27.
//

import UIKit

@available(iOS 14.0, *)
class ProductListCell: UICollectionViewListCell {
    var product: Product?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = ProductContentConfiguration().updated(for: state)
        newConfiguration.productName = product?.name
        newConfiguration.stock = product?.stock
        newConfiguration.discountedPrice = product?.discountedPrice
        newConfiguration.price = product?.price
        newConfiguration.thumbnailImage = product?.thumbnailURL
        newConfiguration.currency = product?.currency
        
        contentConfiguration = newConfiguration
    }
    
    
}
