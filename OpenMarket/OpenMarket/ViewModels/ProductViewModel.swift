//
//  ProductViewModel.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

import UIKit

class ProductViewModel {
    private let repository: ProductRepository = RepositoryInjection.injectProductRepository()
    var updateView: () -> Void = {}
    var addedProduct: () -> Void = {}

    var product: Product? {
        didSet {
            self.updateView()
        }
    }

    var successPostProduct: Bool? {
        willSet {
            if newValue == true {
                self.addedProduct()
            }
        }
    }

    func product(productId: Int) {
        self.repository.product(productId: productId) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let product):
                self.product = product
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }

    func addProduct(postProduct: PostProduct, productImages: [UIImage?]) {
        self.repository.addProduct(postProduct: postProduct, productImages: productImages) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let product):
                self.successPostProduct = true
            case .failure(let error):
                self.successPostProduct = false
                print(error.errorDescription)
            }
        }
    }
}
