//
//  ListProductStackView.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/03.
//

import UIKit

class ListProductStackView: BaseStackView {

    lazy var listNameAndPriceStackView = ListNameAndPriceStackView()

    init() {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.distribution = .fill
        self.spacing = CGFloat(10)
        self.alignment = .center
    }

    let productThumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        return imageView
    }()

    let productStock: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        return label
    }()

    override func configure() {
        super.configure()

        addArrangedSubview(self.productThumbnail)
        addArrangedSubview(self.listNameAndPriceStackView)
        addArrangedSubview(self.productStock)
    }
}
