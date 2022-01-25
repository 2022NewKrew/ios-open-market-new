//
//  ProductListRepository.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

protocol ProductListRepository {
    func productList(pageNumber: Int, itemPerPage: Int , completion: @escaping (Result<ProductList?, NetworkError>) -> Void)
}
