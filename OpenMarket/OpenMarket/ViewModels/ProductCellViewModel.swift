//
//  ProductCellViewModel.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/08.
//

import UIKit

class ProductCellViewModel {
    private let repository: ProductRepository = RepositoryInjection.injectProductRepository()
    private let imageCache = NSCache<NSString, UIImage>()
    var updateImage: () -> Void = {}

    var productThumbnailImage: UIImage? {
        didSet {
            self.updateImage()
        }
    }

    func productThumbnailImage(thumbnailUrl: String, indexPath: IndexPath, collectionView: UICollectionView, cell: ProductCell) {
        if let image = self.imageCache.object(forKey: thumbnailUrl as NSString) {
            self.productThumbnailImage = image
            return
        }

        guard let url = URL(string: thumbnailUrl) else { return }

        self.repository.image(url: url) { [weak self] data in
            guard let self = self,
              let thumbnailImage = UIImage(data: data)
            else {
                return
            }

            DispatchQueue.main.async {
                if indexPath == collectionView.indexPath(for: cell) {
                    self.imageCache.setObject(thumbnailImage, forKey: thumbnailUrl as NSString)
                    self.productThumbnailImage = thumbnailImage
                }
            }
        }
    }
}

