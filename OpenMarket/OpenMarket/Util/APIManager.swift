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
        guard let url = URL(string: apiHost + "healthChecker") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            completion(.success(true))
        }
        
        task.resume()
    }
    
    func fetchProductList(pageNo: Int, itemsPerPage: Int, completion: @escaping (Result<Page,Error>) -> Void) {
        var urlComponents = URLComponents(string: apiHost + "api/products")
        let queryItems :[URLQueryItem] = [
            URLQueryItem(name: "page_no", value: String(pageNo)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else { return }
            do {
                let page = try JSONDecoder.isoSnakeJSONDecoder().decode(Page.self, from: data)
                completion(.success(page))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchProduct(productId: Int, completion: @escaping (Result<Product,Error>) -> Void) {
        guard let url = URL(string: apiHost + "api/products/\(productId)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else { return }
            do {
                let product = try JSONDecoder.isoSnakeJSONDecoder().decode(Product.self, from: data)
                completion(.success(product))
            } catch {
                print(String(describing: error))
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
