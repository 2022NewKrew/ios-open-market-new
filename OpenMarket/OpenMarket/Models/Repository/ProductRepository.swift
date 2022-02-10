//
//  ProductRepository.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

import UIKit

protocol ProductRepository {
    func product(productId: Int, completion: @escaping (Result<Product?, NetworkError>) -> Void)
    func productSecret()
    func addProduct(postProduct: PostProduct, productImages: [UIImage?], completion: @escaping (Result<Product?, NetworkError>) -> Void)
    func updateProduct()
    func deleteProduct()
}
