//
//  ProductInfoTextField.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//

import UIKit

class ProductInfoTextField: UITextField {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.borderStyle = .roundedRect
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    var isValidate: Bool = false {
        willSet {
            if newValue {
                self.layer.borderColor = UIColor.systemGray5.cgColor
                return
            }
            self.layer.borderColor = UIColor.systemOrange.cgColor
        }
    }
}
