//
//  ProductDetailViewModel.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

class ProductDetailViewModel {
    private let repository: OpenMarketRepository = OpenMarketRepositoryInjection.injectOpenMarketRepository()
    var updateView: () -> Void = {}

    var product: Product? {
        didSet {
            self.updateView()
        }
    }

    func product(productId: Int) {
        self.repository.product(productId: productId) { result in
            switch result {
            case .success(let product):
                self.product = product
            case .failure(let error):
                print(error.description)
            }
        }
    }
}
