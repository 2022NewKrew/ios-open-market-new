//
//  UIView+Extension.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//

import UIKit

extension UIView {
    var firstResponder: UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}
