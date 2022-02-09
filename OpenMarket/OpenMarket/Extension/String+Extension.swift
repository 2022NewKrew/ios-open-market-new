//
//  String+Extension.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        return attributeString
    }
    
    var isNotEmtpy: Bool {
        return !self.isEmpty
    }
    
    init?(_ value: Float?) {
        guard let floatValue = value else {
            return nil
        }
        let intValue = Int(floatValue)
        self = "\(intValue)"
    }
    
    init?(_ value: Int?) {
        guard let value = value else {
            return nil
        }
        self = "\(value)"
    }
}
