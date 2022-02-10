//
//  JSONConverter.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/24.
//

import Foundation

struct JSONConverter {

    private init() {}

    static func decode<T: Decodable>(_ decodingType: T.Type, from jsonData: Data) -> T? {
        let decoder: JSONDecoder = JSONDecoder()
        do {
            let response = try decoder.decode(decodingType, from: jsonData)
            return response
        } catch {
            return nil
        }
    }

    static func encode<T: Codable>(_ model: T) -> Data? {
        let encoder: JSONEncoder = JSONEncoder()
         do {
             let response = try encoder.encode(model)
             return response
         } catch {
             return nil
         }
     }
}
