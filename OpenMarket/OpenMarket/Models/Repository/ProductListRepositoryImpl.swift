//
//  ProductListRepositoryImpl.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

struct ProductListRepositoryImpl: ProductListRepository {

    private let networkManager = NetworkManager()

    func productList(pageNumber: Int, itemPerPage: Int, completion: @escaping (Result<ProductList?, NetworkError>) -> Void) {
        guard let url = OpenMarketURL.productList(pageNumber: pageNumber, itemPerPage: itemPerPage).url else {
            completion(.failure(.invalidURL))
            return
        }

        self.networkManager.get(url: url, completion: completion)
    }
}
