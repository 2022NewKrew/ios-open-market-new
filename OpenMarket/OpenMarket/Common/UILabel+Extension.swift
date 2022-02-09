//
//  UILabel+Extension.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/03.
//

import UIKit

extension UILabel {
    func strikethrough(labelText: String) {
        let attributeString = NSMutableAttributedString(string: labelText)
        attributeString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        attributeString.addAttribute(
            .foregroundColor,
            value: UIColor.systemRed,
            range: NSMakeRange(0, attributeString.length)
        )
        self.attributedText = attributeString
    }
}
