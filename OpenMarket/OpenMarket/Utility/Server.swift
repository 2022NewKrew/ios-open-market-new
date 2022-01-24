//
//  Server.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

struct Server {
    static let shared = Server()
    
    private init() {}
    
    func getProductList(numberOfPage: Int, itemsPerPage: Int) {
        Connector.shared.get(from: "api/products?page_no=\(numberOfPage)&items_per_page=\(itemsPerPage)", type: Products.self)
    }
    
    func getDetailOfProduct(productId: Int) {
        Connector.shared.get(from: "api/products/\(productId)", type: Product.self)
    }
}
