//
//  API.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation
import UIKit

class APIManager {
    private let apiHost = "https://market-training.yagom-academy.kr/"
    private let vendorId = "b3a482d1-7217-11ec-abfa-518d1345f072"
    private let secretKey = "3yEw7@dbb?+MY=Kg"
    
    static let shared = APIManager()
    
    private init() { }
    
    func checkServer(completion: @escaping (Result<Bool,Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: healthcheckURL()) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.responseError))
                return
            }
            completion(.success(true))
        }
        
        task.resume()
    }
    
    func healthcheckURL() -> URL {
        guard let url = URL(string: apiHost + "healthChecker") else { fatalError("wrong url format") }
        return url
    }
    
    func fetchProductList(pageNo: Int, itemsPerPage: Int, completion: @escaping (Result<Page,Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: productListURL(pageNo, itemsPerPage)) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            do {
                let page = try JSONDecoder.snakeToCamelJsonDecoder().decode(Page.self, from: data)
                completion(.success(page))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func productListURL(_ pageNo: Int,_ itemsPerPage: Int) -> URL {
        var urlComponents = URLComponents(string: apiHost + "api/products")
        let queryItems :[URLQueryItem] = [
            URLQueryItem(name: "page_no", value: String(pageNo)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { fatalError("wrong url formmat") }
        return url
    }
    
    func fetchProduct(productId: Int, completion: @escaping (Result<Product,Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: productUrl(with: productId)) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            do {
                let product = try JSONDecoder.snakeToCamelJsonDecoder().decode(Product.self, from: data)
                completion(.success(product))
            } catch {
                print(String(describing: error))
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func updateProduct(productId: Int,input: ProductInput,
                       completion: @escaping(Result<Bool,Error>) -> Void) {
        let parameters: [String: String] = ["name": input.name,
                                            "descriptions": input.descriptions,
                                            "price": String(input.price),
                                            "currency": input.currency.rawValue,
                                            "discounted_price": String(input.discountedPrice),
                                            "stock": String(input.stock),
                                            "secret": secretKey]
        var data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print(error)
        }
        var urlRequest = productUpdatUrlRequest(with: productId)
        urlRequest.httpBody = data
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.responseError))
                return
            }
            completion(.success(true))
        }
        
        task.resume()
    }
    
    func productUpdatUrlRequest(with productId: Int) -> URLRequest {
        guard let url = URL(string: apiHost + "api/products/\(productId)") else { fatalError()}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.setValue(vendorId, forHTTPHeaderField: "identifier")
        return urlRequest
    }
    
    func productPostUrlRequest() -> URLRequest {
        guard let url = URL(string: apiHost + "api/products") else {
            fatalError("wrong url format")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(vendorId, forHTTPHeaderField: "identifier")
        return urlRequest
    }
    
    func postProduct(input: ProductInput,
                    images:[UIImage],
                    completion: @escaping(Result<Bool,Error>) -> Void) {
        let boundary = boundaryString()
        let parameters: [String: String] = ["name": input.name,
                                            "descriptions": input.descriptions,
                                            "price": String(input.price),
                                            "currency": input.currency.rawValue,
                                            "discounted_price": String(input.discountedPrice),
                                            "stock": String(input.stock),
                                            "secret": secretKey]
        var body: [String: String] = [:]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            body = ["params": String(data: jsonData, encoding: .utf8) ?? ""]
        } catch {
            print(error)
        }
        let bodyData = createMultiformBody(parameters: body, boundary: boundary, images: images)
        var urlRequest = productPostUrlRequest()
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)",
                forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = bodyData

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.responseError))
                return
            }
             //   print(String(data: data!, encoding: .utf8))
            completion(.success(true))
            
        }
        task.resume()
    }
    
    func productUrl(with productId: Int) -> URL{
        guard let url = URL(string: apiHost + "api/products/\(productId)") else {
            fatalError("wrong url formmat")
        }
        
        return url
    }
    
    func productSecretURLRequest(with productId: Int) -> URLRequest {
        guard let url = URL(string: apiHost + "api/products/\(productId)/secret") else {fatalError()}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(vendorId, forHTTPHeaderField: "identifier")
        return urlRequest
    }
    
    func fetchProductSecretKey(productId: Int, completion: @escaping(Result<String,Error>) -> Void) {
        let parameters: [String: String] = ["secret": secretKey]
        var data: Data?
        do {
            data = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print(error)
        }
        var urlRequest = productSecretURLRequest(with: productId)
        urlRequest.httpBody = data
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode), let data = data else {
                completion(.failure(APIError.responseError))
                return
            }
            guard let secret = String(data: data, encoding: .utf8) else { return }
            completion(.success(secret))
        }
        
        task.resume()
    }
    
    func productDeleteUrlRequest(productId: Int, secretKey: String) -> URLRequest {
        guard let url = URL(string: apiHost + "api/products/\(productId)/\(secretKey)") else { fatalError()}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue(vendorId, forHTTPHeaderField: "identifier")
        return urlRequest
    }
    
    func deleteProduct(productId: Int, secretKey: String,
                       completion: @escaping(Result<Bool,Error>) -> Void) {
        let urlRequest = productDeleteUrlRequest(productId: productId, secretKey: secretKey)
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(APIError.responseError))
                return
            }
            completion(.success(true))
        }
        
        task.resume()
    }
                           
    enum APIError: Error {
        case noData
        case responseError
        case dataParsingError
        
        var localizedDescription: String {
            switch self {
            case .noData:
                return "Data is empty"
            case .responseError:
                return "Response Error occured!"
            case .dataParsingError:
                return "failed to parse Data"
            }
        }
    }
}

extension APIManager {
    func boundaryString() -> String {
        "Boundary-\(UUID().uuidString)"
    }
    
    func createMultiformBody(parameters: [String: String],
                           boundary: String,
                           images: [UIImage]
    ) -> Data {
        var body = Data()
        let imgDataKey = "images"
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"")
            body.appendString("\r\n\r\n\(value)\r\n")
        }
        
        for image in images {
            let filename = "image\(UUID()).jpeg"
            guard let data = image.compressTo(0.3) else {
                print("failed to convert image into png")
                continue
            }
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: header\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
        }
        body.appendString("--".appending(boundary.appending("--")))
        body.appendString("\r\n")
        
        return body as Data
    }
}
