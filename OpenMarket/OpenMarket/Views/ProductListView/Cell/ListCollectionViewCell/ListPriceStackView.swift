//
//  ListPriceStackView.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/03.
//

import UIKit

class ListPriceStackView: BaseStackView {

    init() {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.spacing = CGFloat(10)
        self.alignment = .leading
    }

    let productOriginPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    let productDiscountedPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    override func configure() {
        super.configure()

        addArrangedSubview(self.productOriginPrice)
        addArrangedSubview(self.productDiscountedPrice)
    }
}
