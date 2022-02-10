//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

import Foundation
import UIKit

struct NetworkManager {

    private let session = URLSession.shared

    func get<T: Decodable>(url: URL, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.description

        self.sessionDataTastRequest(request: request, completion: completion)
    }

    func post<T: Decodable>(url: URL, postProduct: PostProduct, productImages: [UIImage?], completion: @escaping (Result<T?, NetworkError>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.description

        // Header
        request.setValue(Constant.identifier, forHTTPHeaderField: "identifier")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Body
        request.httpBody = self.createBody(
            boundary: boundary,
            postProduct: postProduct,
            productImages: productImages
        )

        self.sessionDataTastRequest(request: request, completion: completion)
    }

    func patch<T: Decodable>(url: URL, postProduct: PostProduct, productImages: [UIImage?], completion: @escaping (Result<T?, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.patch.description

        // Header
        request.setValue(Constant.identifier, forHTTPHeaderField: "identifier")

        // Body
        request.httpBody = JSONConverter.encode(postProduct)

        self.sessionDataTastRequest(request: request, completion: completion)
    }

    @discardableResult 
    private func createBody(boundary: String, postProduct: PostProduct, productImages: [UIImage?]) -> Data? {
        guard let boundaryPrefix = "--\(boundary)\r\n".data(using: .utf8),
            let boundaryPostfix = "--\(boundary)--\r\n".data(using: .utf8),
            let lineAlignment = "\r\n".data(using: .utf8),
            let paramsContentDisposition = "Content-Disposition: form-data; name=params\r\n".data(using: .utf8),
            let paramsContentType = "Content-Type: application/json\r\n\r\n".data(using: .utf8),
            let postProductJson = JSONConverter.encode(postProduct),
            let imagesContentDisposition = "Content-Disposition: form-data; name=images; filename=image.jpeg\r\n".data(using: .utf8),
            let imagesContentType = "Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)
        else {
            return nil
        }

        var body = Data()
        body.append(boundaryPrefix)

        body.append(paramsContentDisposition)
        body.append(paramsContentType)
        body.append(postProductJson)
        body.append(lineAlignment)

        let imageDatas = productImages
            .compactMap {
                $0?.jpegData(compressionQuality: 0.1)
            }
        imageDatas.map {
            body.append(boundaryPrefix)
            body.append(imagesContentDisposition)
            body.append(imagesContentType)
            body.append($0)
            body.append(lineAlignment)
        }

        body.append(boundaryPostfix)
        return body
    }

    func image(url: URL, completion: @escaping (Data) -> Void) {
        session.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }

            completion(data)
        }.resume()
    }

    private func sessionDataTastRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        self.session.dataTask(with: request) { data, response, error in
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
}
