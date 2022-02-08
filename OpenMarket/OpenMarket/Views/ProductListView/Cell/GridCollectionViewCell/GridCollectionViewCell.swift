//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/02.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell, ProductCell {

    var productCellViewModel = ProductCellViewModel()

    private lazy var gridProductStackView = GridProductStackView()

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
        self.productThumbnail = self.gridProductStackView.productThumbnail
        self.productName = self.gridProductStackView.productName
        self.productOriginPrice = self.gridProductStackView.productOriginPrice
        self.productDiscountedPrice = self.gridProductStackView.productDiscountedPrice
        self.productStock = self.gridProductStackView.productStock
    }

    private func bindConstraints() {
        contentView.addSubview(self.gridProductStackView)
        layer.cornerRadius = CGFloat(12.0)
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = CGFloat(1.0)

        NSLayoutConstraint.activate([
            self.gridProductStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.gridProductStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            self.gridProductStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(10)),
            self.gridProductStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CGFloat(-10))
        ])
    }
}
