//
//  ProductListViewModel.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

import UIKit

class ProductListViewModel {
    private let repository: ProductListRepository = RepositoryInjection.injectProductListRepository()
    private var pageNumber = 0
    var updateView: (Int) -> Void = { _ in }
    var isPaginating = false

    var products: [Product] = [] {
        didSet {
            self.updateView(self.pageNumber)
        }
    }

    func productList() {
        self.isPaginating = true
        self.pageNumber += 1
        self.repository.productList(pageNumber: self.pageNumber, itemsPerPage: Constant.itemsPerPage) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let productList):
                guard let productList = productList,
                      let products = productList.products
                else {
                    return
                }

                self.products.append(contentsOf: products)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
}
