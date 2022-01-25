//
//  OpenMarketRepositoryRemoteDataSourceImpl.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

import Foundation

struct OpenMarketRepositoryRemoteDataSourceImpl: OpenMarketRepository {

    private let networkManager = NetworkManager()

    func productList(pageNumber: Int, itemPerPage: Int, completion: @escaping (Result<ProductList?, NetworkError>) -> Void) {
        guard let url = OpenMarketURL.productList(pageNumber, itemPerPage).url else {
            completion(.failure(.invalidURL))
            return
        }

        self.networkManager.get(url: url, completion: completion)
    }

    func product(productId: Int, completion: @escaping (Result<Product?, NetworkError>) -> Void) {
        guard let url = OpenMarketURL.product(productId).url else {
            completion(.failure(.invalidURL))
            return
        }

        self.networkManager.get(url: url, completion: completion)
    }

    func productSecret() {

    }

    func addProduct() {

    }

    func updateProduct() {

    }

    func deleteProduct() {
        
    }
}
