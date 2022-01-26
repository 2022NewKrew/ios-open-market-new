//
//  JSONDecoder+Extension.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

extension JSONDecoder {
    static func snakeToCamelJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
