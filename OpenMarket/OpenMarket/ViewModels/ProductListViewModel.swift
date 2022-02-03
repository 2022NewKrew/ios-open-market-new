//
//  ProductListViewModel.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

import UIKit

class ProductListViewModel {
    private let repository: ProductListRepository = RepositoryInjection.injectProductListRepository()
    var updateView: () -> Void = {}
    var updateImage: () -> Void = {}

    var productList: ProductList? {
        didSet {
            self.updateView()
        }
    }

    var productThumbnailImage: UIImage? {
        didSet {
            self.updateImage()
        }
    }

    func productList(pageNumber: Int, itemPerPage: Int) {
        self.repository.productList(pageNumber: pageNumber, itemPerPage: itemPerPage) { result in
            switch result {
            case .success(let productList):
                self.productList = productList
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }

    func image(url: URL) {
        self.repository.image(url: url) { data in
            DispatchQueue.main.async {
                self.productThumbnailImage = UIImage(data: data)
            }
        }
    }
}
