//
//  ProductRepositoryImpl.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

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

    func addProduct() {

    }

    func updateProduct() {

    }

    func deleteProduct() {
        
    }
}
