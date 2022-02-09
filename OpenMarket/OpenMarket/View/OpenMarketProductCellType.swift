//
//  OpenMarketProductCellType.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/01.
//

import Foundation
import UIKit

protocol OpenMarketProductCellType: UICollectionViewCell {
    var thumbnailImageView: UIImageView! { get set }
    var productNameLabel: UILabel! { get set }
    var stockLabel: UILabel! { get set }
    var notDiscountedPriceLabel: UILabel! { get set }
    var sellingPriceLabel: UILabel! { get set }
    
    func configure(of product: OpenMarketProduct)
}

extension OpenMarketProductCellType {
    func configure(of product: OpenMarketProduct) {
        self.productNameLabel.text = product.name ?? ListConstants.unknwon
        self.stockLabel.text = "잔여수량 : \(product.stock ?? 0)"
        let stock = product.stock ?? 0
        if stock == 0 {
            self.stockLabel.text = "품절"
            self.stockLabel.textColor = .systemOrange
        }
        
        guard let price = product.price else {
            self.notDiscountedPriceLabel.isHidden = true
            self.sellingPriceLabel.text = ListConstants.unknwon
            return
        }
        
        let currecny = product.currency ?? .krw
        
        guard let discount = product.discountedPrice,
              discount != 0 else {
                  self.notDiscountedPriceLabel.isHidden = true
                  self.sellingPriceLabel.text = currecny.priceString(of: price)
                  return
              }
        
        self.notDiscountedPriceLabel.text = currecny.priceString(of: price)
        self.sellingPriceLabel.text = currecny.priceString(of: price - discount)
    }
}
