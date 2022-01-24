//
//  OpenMarketRepository.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

protocol OpenMarketRepository {
    // GET
    func productList()
    func product()
    func productSecret()

    // POST
    func addProduct()

    // PATCH
    func updateProduct()

    // DELETE
    func deleteProduct()
}
