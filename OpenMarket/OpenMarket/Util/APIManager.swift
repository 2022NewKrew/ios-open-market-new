//
//  API.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/24.
//

import Foundation

class APIManager {
    private let apiHost = "https://market-training.yagom-academy.kr/"
    
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
