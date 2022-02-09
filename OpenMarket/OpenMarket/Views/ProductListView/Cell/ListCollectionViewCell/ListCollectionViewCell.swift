//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/02.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell, ProductCell {

    var productCellViewModel = ProductCellViewModel()

    private lazy var listProductStackView = ListProductStackView()
    private lazy var listNameAndPriceStackView = self.listProductStackView.listNameAndPriceStackView
    private lazy var listPriceStackView = self.listNameAndPriceStackView.listPriceStackView

    var productThumbnail: UIImageView!
    var productName: UILabel!
    var productOriginPrice: UILabel!
    var productDiscountedPrice: UILabel!
    var productStock: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.bindProperties()
        self.bindConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func bindProperties() {
        self.productThumbnail = self.listProductStackView.productThumbnail
        self.productName = self.listNameAndPriceStackView.productName
        self.productOriginPrice = self.listPriceStackView.productOriginPrice
        self.productDiscountedPrice = self.listPriceStackView.productDiscountedPrice
        self.productStock = self.listProductStackView.productStock
    }

    private func bindConstraints() {
        contentView.addSubview(self.listProductStackView)
        layer.cornerRadius = CGFloat(12.0)
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = CGFloat(1.0)

        NSLayoutConstraint.activate([
            self.listProductStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: CGFloat(10)),
            self.listProductStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: CGFloat(-20)),
            self.listProductStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.listProductStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.productThumbnail.heightAnchor.constraint(equalToConstant: CGFloat(100))
        ])
    }
}
