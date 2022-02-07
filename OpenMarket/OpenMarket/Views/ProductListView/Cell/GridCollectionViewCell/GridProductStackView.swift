//
//  GridProductStackView.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/03.
//

import UIKit

class GridProductStackView: BaseStackView {

    init() {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .equalSpacing
        self.spacing = CGFloat(1)
        self.alignment = .center
    }

    let productThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        return imageView
    }()

    let productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let productOriginPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    let productDiscountedPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    let productStock: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()

    override func configure() {
        super.configure()

        addArrangedSubview(self.productThumbnail)
        addArrangedSubview(self.productName)
        addArrangedSubview(self.productOriginPrice)
        addArrangedSubview(self.productDiscountedPrice)
        addArrangedSubview(self.productStock)
    }
}
