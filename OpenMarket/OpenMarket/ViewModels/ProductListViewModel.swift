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
    var updateView: (Int) -> Void = {_ in }
    var updateImage: () -> Void = {}
    var isPaginating = false

    var products: [Product] = [] {
        didSet {
            self.updateView(self.pageNumber)
        }
    }

    var productThumbnailImage: UIImage? {
        didSet {
            self.updateImage()
        }
    }

    func productList() {
        self.isPaginating = true
        self.pageNumber += 1
        self.repository.productList(pageNumber: self.pageNumber, itemsPerPage: Constant.itemsPerPage) { result in
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

    func productThumbnailImage(url: URL) {
        self.repository.image(url: url) { data in
            DispatchQueue.main.async {
                self.productThumbnailImage = UIImage(data: data)
            }
        }
    }
}
