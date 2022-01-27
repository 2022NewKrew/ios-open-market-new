//
//  ProductContentConfiguration.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import UIKit

@available(iOS 14.0, *)
struct ProductContentConfiguration: UIContentConfiguration, Hashable {
    
    var productName: String?
    var thumbnailImage: URL?
    var price: Double?
    var discountedPrice: Double?
    var stock: Int?
    var currency: Currency?
    
    func makeContentView() -> UIView & UIContentView {
        return ProductListContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> ProductContentConfiguration {
        // guard let state = state as? UICellConfigurationState else { return self }\
        return self
    }
}
