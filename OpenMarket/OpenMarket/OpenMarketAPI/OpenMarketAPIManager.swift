//
//  OpenMarketAPIManager.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

struct OpenMarketAPIManager {
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    var decoder: JSONDecoder = JSONDecoder()
    var urlSession: URLSession
    
    func getOpenMarketProductList(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<OpenMarketProudctListGetResponse, Error>) -> Void) {
        guard let request = OpenMarketAPIRouter
                .getOpenMarketProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
                .asURLRequest() else {
                    completion(.failure(OpenMarketAPIError.invalidRequest))
                    return
                }
        
        let task = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let result = self.handleOpenMarketAPIGetResponse(responseType: OpenMarketProudctListGetResponse.self, response: response, data: data)
            completion(result)
        })
        task.resume()
    }
    
    func getOpenMarketProductDetail(productId: Int, completion: @escaping (Result<OpenMarketProductDetailGetResponse,Error>) -> Void) {
        guard let request = OpenMarketAPIRouter
                .getDetailOpenMarketProduct(productId: productId)
                .asURLRequest() else {
                    completion(.failure(OpenMarketAPIError.invalidRequest))
                    return
                }
        
        let task = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let result = self.handleOpenMarketAPIGetResponse(responseType: OpenMarketProductDetailGetResponse.self, response: response, data: data)
            completion(result)
        })
        task.resume()
    }
    
    private func handleOpenMarketAPIGetResponse<T: Decodable>(responseType: T.Type, response: URLResponse?, data: Data?) -> Result<T, Error> {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(OpenMarketAPIError.notHTTPResponse)
        }
        
        switch httpResponse.statusCode {
        case (200...399):
            guard let data = data else {
                return .failure(OpenMarketAPIError.noData)
            }
            
            guard let response = try? decoder.decode(responseType.self, from: data) else {
                return .failure(OpenMarketAPIError.failDecoding)
            }
            return .success(response)
        case (400...499):
            return .failure(OpenMarketAPIError.badRequest)
        case (500...599):
            return .failure(OpenMarketAPIError.serverError)
        default:
            return .failure(OpenMarketAPIError.unknown)
        }
    }
    
}
