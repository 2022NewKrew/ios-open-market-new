//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/02.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell, ProductCell {

    private lazy var gridProductStackView = GridProductStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    func updateCell(product: Product?) {
        guard let product = product else { return }

        self.gridProductStackView.productThumbnail.image = UIImage(systemName: "note")
        self.gridProductStackView.productName.text = product.name
        self.setPrice(product: product)
        self.setStock(product: product)
    }

    private func setPrice(product: Product) {
        self.gridProductStackView.productOriginPrice.text = "\(product.currency) \(product.price)"
        if product.bargainPrice == 0 {
            self.gridProductStackView.productDiscountedPrice.isHidden = true
        } else {
            self.gridProductStackView.productOriginPrice.strikethrough(labelText: self.gridProductStackView.productOriginPrice.text ?? "")
            self.gridProductStackView.productDiscountedPrice.text = "\(product.currency) \(product.discountedPrice)"
        }
    }

    private func setStock(product: Product) {
        if product.stock == 0 {
            self.gridProductStackView.productStock.text = Constant.soldOutText
            self.gridProductStackView.productStock.textColor = .orange
        } else {
            self.gridProductStackView.productStock.text = "\(Constant.remainingQuantityText): \(product.stock)"
            self.gridProductStackView.productStock.textColor = .gray
        }
    }
}
