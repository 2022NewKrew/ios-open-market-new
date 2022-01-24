//
//  ProductListViewModel.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

class ProductListViewModel {
    private let repository: OpenMarketRepository = OpenMarketRepositoryInjection.injectOpenMarketRepository()
    var updateView: () -> Void = {}
}
