//
//  JSONFileDecoder.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

import Foundation

struct JSONFileDecoder {

    private init() {}

    static func decodeJson<T: Decodable>(_ decodingType: T.Type, from jsonData: Data) -> T? {
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let response = try decoder.decode(decodingType, from: jsonData)
            return response
        } catch {
            return nil
        }
    }
}
