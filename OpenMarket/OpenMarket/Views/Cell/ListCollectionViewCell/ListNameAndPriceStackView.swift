//
//  ListNameAndPriceStackView.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/03.
//

import UIKit

class ListNameAndPriceStackView: BaseStackView {

    lazy var listPriceStackView = ListPriceStackView()

    init() {
        super.init(frame: .zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = CGFloat(1)
        self.alignment = .leading
    }

    let productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    override func configure() {
        super.configure()

        addArrangedSubview(self.productName)
        addArrangedSubview(self.listPriceStackView)
    }
}
