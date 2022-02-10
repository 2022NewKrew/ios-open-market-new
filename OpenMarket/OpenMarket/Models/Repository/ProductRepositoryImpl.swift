//
//  ProductRepositoryImpl.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

import UIKit

struct ProductRepositoryImpl: ProductRepository {

    private let networkManager = NetworkManager()

    func product(productId: Int, completion: @escaping (Result<Product?, NetworkError>) -> Void) {
        guard let url = OpenMarketURL.product(productId: productId).url else {
            completion(.failure(.invalidURL))
            return
        }

        self.networkManager.get(url: url, completion: completion)
    }

    func productSecret() {

    }

    func addProduct(postProduct: PostProduct, productImages: [UIImage?], completion: @escaping (Result<Product?, NetworkError>) -> Void) {
        guard let url = OpenMarketURL.addProduct.url else {
            completion(.failure(.invalidURL))
            return
        }

        self.networkManager.post(url: url, postProduct: postProduct, productImages: productImages, completion: completion)
    }

    func updateProduct(productId: Int, postProduct: PostProduct, productImages: [UIImage?], completion: @escaping (Result<Product?, NetworkError>) -> Void) {
        guard let url = OpenMarketURL.updateProduct(productId: productId).url else {
            completion(.failure(.invalidURL))
            return
        }

        self.networkManager.patch(url: url, postProduct: postProduct, productImages: productImages, completion: completion)
    }

    func deleteProduct() {
        
    }

    func image(url: URL, completion: @escaping (Data) -> Void) {
        self.networkManager.image(url: url, completion: completion)
    }
}
