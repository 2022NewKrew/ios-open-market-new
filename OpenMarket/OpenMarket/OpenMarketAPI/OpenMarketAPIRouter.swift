//
//  OpenMarketAPIRouter.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//
import Foundation

enum OpenMarketAPIRouter {
    case getOpenMarketProductList(pageNumber: Int, itemsPerPage: Int)
    case getDetailOpenMarketProduct(productId: Int)
    case postOpenMarektProduct(boundary: String, identifier: String, body: Data)
    case patchOpenMarketProduct(prodcutId: Int, identifier: String, body: Data)
    
    var path: String {
        switch self {
        case .getDetailOpenMarketProduct(let productId), .patchOpenMarketProduct(let productId, _, _):
            return APIConstants.productsEndPoint + "/" + String(productId)
        default: return APIConstants.productsEndPoint
        }
    }
    
    var query: [String : String] {
        var query: [String : String] = [:]
        switch self {
        case .getOpenMarketProductList(let pageNumber, let itemsPerPage):
            query = [
                APIConstants.pageNo : String(pageNumber),
                APIConstants.itemsPerPage: String(itemsPerPage)
            ]
            
        default: break
        }
        return query
    }
    
    var header: [String: String] {
        switch self {
        case .postOpenMarektProduct(let boundary, let identifier, _):
            return [
                HTTPHeaderField.contentType.rawValue : ContentType.multiPartForm(boundary: boundary).value,
                APIConstants.identifier : identifier
            ]
        case .patchOpenMarketProduct(_, let identifier, _):
            return [
                APIConstants.identifier : identifier
            ]
        default:
            return [:]
        }
    }
    
    var body: Data? {
        switch self {
        case .postOpenMarektProduct(_, _, let data), .patchOpenMarketProduct(_, _, let data):
            return data
        default:
            return nil
        }
    }
    
    var requestURL: String {
        return APIConstants.baseURL + "/" + self.path
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case  .getOpenMarketProductList, .getDetailOpenMarketProduct: return .get
        case .postOpenMarektProduct: return .post
        case .patchOpenMarketProduct: return .patch
        }
    }
    
    func asURLRequest() -> URLRequest? {
        guard var urlComponets = URLComponents(string: self.requestURL) else {
            return nil
        }
        
        urlComponets.queryItems = self.query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = urlComponets.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        self.header.forEach {
            urlRequest.setValue($1, forHTTPHeaderField: $0)
        }
        
        urlRequest.httpBody = body
        
        return urlRequest
    }
}
