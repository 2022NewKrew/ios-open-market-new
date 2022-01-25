//
//  OpenMarketRepository.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

protocol OpenMarketRepository {
    func productList(pageNumber: Int, itemPerPage: Int , completion: @escaping (Result<ProductList?, NetworkError>) -> Void)
    func product(productId: Int, completion: @escaping (Result<Product?, NetworkError>) -> Void)
    func productSecret()
    func addProduct()
    func updateProduct()
    func deleteProduct()
}
