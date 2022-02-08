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
    
    func productPostUrlRequest() -> URLRequest {
        guard let url = URL(string: apiHost + "api/products") else {
            fatalError("wrong url format")
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(vendorId, forHTTPHeaderField: "identifier")
 
        return urlRequest
    }
    
    func addProduct(name: String,
                    descriptions: String,
                    price: Double,
                    currency: Currency,
                    discountedPrice: Double,
                    stock: Int,
                    images:[UIImage],
                    completion: @escaping(Result<Bool,Error>) -> Void) {
        let boundary = boundaryString()
        let parameters: [String: String] = ["name": name,
                                      "descriptions": descriptions,
                                      "price": String(price),
                                      "currency": currency.rawValue,
                                      "discounted_price": String(discountedPrice),
                                      "stock": String(stock),
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
                           
    enum APIError: Error {
        case noData
        case responseError
        
        var localizedDescription: String {
            switch self {
            case .noData:
                return "Data is empty"
            case .responseError:
                return "Response Error occured!"
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
            let mimeType = "image/jpeg"
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
