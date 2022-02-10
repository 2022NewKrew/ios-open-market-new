//
//  OpenMarketAPIManager.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import UIKit

struct OpenMarketAPIManager {
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    var urlSession: URLSession
    
    func getOpenMarketProductList(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<OpenMarketProductListResponse, Error>) -> Void) {
        guard let request = OpenMarketAPIRouter
                .getOpenMarketProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage)
                .asURLRequest() else {
                    completion(.failure(OpenMarketAPIError.invalidRequest))
                    return
                }
        
        let task = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
            let result = self.handleOpenMarketAPIResponse(responseType: OpenMarketProductListResponse.self, response: response, data: data, error: error)
            completion(result)
        })
        task.resume()
    }
    
    func getOpenMarketProductDetail(productId: Int, completion: @escaping (Result<OpenMarketProductResponse, Error>) -> Void) {
        guard let request = OpenMarketAPIRouter
                .getDetailOpenMarketProduct(productId: productId)
                .asURLRequest() else {
                    completion(.failure(OpenMarketAPIError.invalidRequest))
                    return
                }
        
        let task = self.urlSession.dataTask(with: request, completionHandler: { data, response, error in
            let result = self.handleOpenMarketAPIResponse(responseType: OpenMarketProductResponse.self, response: response, data: data, error: error)
            completion(result)
        })
        task.resume()
    }
    
    func createOpenMarketProduct(identifier: String, params: OpenMarketProductPostParam, images: [UIImage], completion: @escaping (Result<OpenMarketProductResponse, Error>) -> Void) {
        let boundary = self.generateBoundaryString()
        let body = self.createOpenMarketProductPostBody(boundary: boundary, params: params, images: images)
        
        guard let request = OpenMarketAPIRouter
                .postOpenMarektProduct(boundary: boundary, identifier: identifier, body: body)
                .asURLRequest() else {
                    completion(.failure(OpenMarketAPIError.invalidRequest))
                    return
                }
        
        let task = self.urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            let result = self.handleOpenMarketAPIResponse(responseType: OpenMarketProductResponse.self, response: response, data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func updateOpenMarketProduct(identifier: String, productId: Int, params: OpenMarketProductPatchParam, completion: @escaping(Result<OpenMarketProductResponse, Error>) -> Void) {
        guard let body = self.createOpenMarketProductPatchBody(params: params) else {
            completion(.failure(OpenMarketAPIError.failEncoding))
            return
        }
        
        guard let request = OpenMarketAPIRouter
                .patchOpenMarketProduct(prodcutId: productId, identifier: identifier, body: body)
                .asURLRequest() else {
                    completion(.failure(OpenMarketAPIError.invalidRequest))
                    return
                }
        
        let task = self.urlSession.dataTask(with: request) { data, response, error in
            let result = self.handleOpenMarketAPIResponse(responseType: OpenMarketProductResponse.self, response: response, data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    private func handleOpenMarketAPIResponse<T: Decodable>(responseType: T.Type, response: URLResponse?, data: Data?, error: Error?) -> Result<T, Error> {
        if let error = error {
            return .failure(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(OpenMarketAPIError.notHTTPResponse)
        }
        
        switch httpResponse.statusCode {
        case (200...399):
            guard let data = data else {
                return .failure(OpenMarketAPIError.noData)
            }
            let decoder = JSONDecoder()
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
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private func createOpenMarketProductPostBody(boundary: String, params: OpenMarketProductPostParam, images: [UIImage]) -> Data? {
        var body = Data()
        body.append(MultipartFormDataConstants.boundaryPrefix(boundary: boundary).value)
        let encoder = JSONEncoder()
        guard let paramData = try? encoder.encode(params) else {
            return nil
        }
        
        body.append(MultipartFormDataConstants.contentDispositionOfText(name: APIConstants.params).value)
        body.append(paramData)
        body.append(MultipartFormDataConstants.lineBreak.value)
        
        var imageDatas = [Data]()
        for image in images {
            if let data = image.jpeg(maximumSizeKb: 300.0) {
                imageDatas.append(data)
            }
        }
        
        for (index,imageData) in imageDatas.enumerated() {
            let fileName = "image\(index).jpg"
            body.append(MultipartFormDataConstants.boundaryPrefix(boundary: boundary).value)
            body.append(MultipartFormDataConstants.contentDispositionOfFile(name: APIConstants.images, fileName: fileName).value)
            body.append(MultipartFormDataConstants.contentTypeOfFile().value)
            body.append(imageData)
            body.append(MultipartFormDataConstants.lineBreak.value)
        }
        
        body.append(MultipartFormDataConstants.boundaryPrefix(boundary: boundary, isLast: true).value)
        return body
    }
    
    private func createOpenMarketProductPatchBody(params: OpenMarketProductPatchParam) -> Data? {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(params)
        return data
    }
}
