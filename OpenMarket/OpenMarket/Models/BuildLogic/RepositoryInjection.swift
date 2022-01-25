//
//  RepositoryInjection.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

struct RepositoryInjection {
    static func injectProductListRepository() -> ProductListRepository {
        return ProductListRepositoryImpl()
    }

    static func injectProductRepository() -> ProductRepository {
        return ProductRepositoryImpl()
    }
}
