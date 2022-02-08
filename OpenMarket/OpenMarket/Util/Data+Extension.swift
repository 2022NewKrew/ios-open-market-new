//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/08.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
