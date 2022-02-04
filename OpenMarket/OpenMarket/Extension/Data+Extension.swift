//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/04.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
