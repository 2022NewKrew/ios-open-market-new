//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

import UIKit

struct NetworkManager {

    private let session = URLSession.shared

    func get<T: Decodable>(url: URL, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.description

        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.transportError))
                return
            }

            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(.networkFailure(statusCode: response.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.missingData))
                return
            }

            guard let decodedData = JSONConverter.decode(T.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }

            completion(.success(decodedData))
        }.resume()
    }

    func image(url: URL, completion: @escaping (Data) -> Void) {
        session.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }

            completion(data)
        }.resume()
    }
}
