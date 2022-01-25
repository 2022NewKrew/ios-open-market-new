//
//  ProductListViewModel.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

class ProductListViewModel {
    private let repository: OpenMarketRepository = OpenMarketRepositoryInjection.injectOpenMarketRepository()
    var updateView: () -> Void = {}

    var productList: ProductList? {
        didSet {
            self.updateView()
        }
    }

    func productList(pageNumber: Int, itemPerPage: Int) {
        self.repository.productList(pageNumber: pageNumber, itemPerPage: itemPerPage) { result in
            switch result {
            case .success(let productList):
                self.productList = productList
            case .failure(let error):
                print(error.description)
            }
        }
    }
}
