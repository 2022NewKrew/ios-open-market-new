//
//  ProductListRepositoryImpl.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

import UIKit

struct ProductListRepositoryImpl: ProductListRepository {

    private let networkManager = NetworkManager()

    func productList(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<ProductList?, NetworkError>) -> Void) {
        guard let url = OpenMarketURL.productList(pageNumber: pageNumber, itemsPerPage: itemsPerPage).url else {
            completion(.failure(.invalidURL))
            return
        }

        self.networkManager.get(url: url, completion: completion)
    }
}
