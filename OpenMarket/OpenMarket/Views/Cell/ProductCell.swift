//
//  ProductCell.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/02.
//

import UIKit

protocol ProductCell: UICollectionViewCell {
    var productListViewModel: ProductListViewModel { get }
    var productThumbnail: UIImageView! { get }
    var productName: UILabel! { get }
    var productOriginPrice: UILabel! { get }
    var productDiscountedPrice: UILabel! { get }
    var productStock: UILabel! { get }

    func updateCell(product: Product?, indexPath: IndexPath, collectionView: UICollectionView)
    func setImage(product: Product, indexPath: IndexPath, collectionView: UICollectionView)
    func setPrice(product: Product)
    func setStock(product: Product)
}

extension ProductCell {
    func updateCell(product: Product?, indexPath: IndexPath, collectionView: UICollectionView) {
        guard let product = product else { return }

        self.productName.text = product.name
        self.setImage(product: product, indexPath: indexPath, collectionView: collectionView)
        self.setPrice(product: product)
        self.setStock(product: product)
    }

    func setImage(product: Product, indexPath: IndexPath, collectionView: UICollectionView) {
        self.productListViewModel.updateImage = { [weak self] cellIndexPath, collectionView in
            guard let self = self,
                let cellIndexPath = cellIndexPath,
                let collectionView = collectionView,
                let collectionViewIndexPath = collectionView.indexPath(for: self)
            else {
                return
            }

            if cellIndexPath == collectionViewIndexPath {
                DispatchQueue.main.async {
                    self.productThumbnail.image = self.productListViewModel.productThumbnailImage
                }
            }
        }
        
        self.productListViewModel.productThumbnailImage(
            thumbnailUrl: product.thumbnail,
            indexPath: indexPath,
            collectionView: collectionView
        )
    }

    func setPrice(product: Product) {
        self.productDiscountedPrice.text = "\(product.currency) \(product.price)"
        if product.bargainPrice == 0 {
            self.productOriginPrice.isHidden = true
        } else {
            self.productOriginPrice.text = "\(product.currency) \(product.discountedPrice)"
            self.productOriginPrice.strikethrough(labelText: self.productOriginPrice.text ?? "")
        }
    }

    func setStock(product: Product) {
        if product.stock == 0 {
            self.productStock.text = Constant.soldOutText
            self.productStock.textColor = .orange
        } else {
            self.productStock.text = "\(Constant.remainingQuantityText): \(product.stock)"
            self.productStock.textColor = .gray
        }
    }
}
