//
//  BaseStackView.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/03.
//

import UIKit

protocol Configurable {
    func configure()
}

class BaseStackView: UIStackView, Configurable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder: NSCoder) has not been implemented")
    }

    func configure() {}
}
