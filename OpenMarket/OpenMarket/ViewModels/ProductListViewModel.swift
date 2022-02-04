//
//  ProductListViewModel.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

import UIKit

class ProductListViewModel {
    private let repository: ProductListRepository = RepositoryInjection.injectProductListRepository()
    private let imageCache = NSCache<NSString, UIImage>()
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

    func productThumbnailImage(thumbnailUrl: String) {
        if let image = self.imageCache.object(forKey: thumbnailUrl as NSString) {
            self.productThumbnailImage = image
            return
        }

        guard let url = URL(string: thumbnailUrl) else {
            return
        }

        self.repository.image(url: url) { data in
            DispatchQueue.main.async {
                guard let thumbnailImage = UIImage(data: data) else { return }

                self.imageCache.setObject(thumbnailImage, forKey: thumbnailUrl as NSString)
                self.productThumbnailImage = thumbnailImage
            }
        }
    }
}
