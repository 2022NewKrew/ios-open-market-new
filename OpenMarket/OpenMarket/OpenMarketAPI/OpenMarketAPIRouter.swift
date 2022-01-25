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
    
    var path: String {
        switch self {
        case .getDetailOpenMarketProduct(let productId): return String(productId)
        default: return ""
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
        return [:]
    }
    
    var baseURL: String {
        return APIConstants.baseURL + "/" + self.path
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case  .getOpenMarketProductList, .getDetailOpenMarketProduct: return .get
        }
    }
    
    func asURLRequest() -> URLRequest? {
        guard var urlComponets = URLComponents(string: self.baseURL) else {
            return nil
        }
        
        urlComponets.queryItems = self.query.map{
            URLQueryItem(name: $0.key, value: $0.value)
        }
        
        guard let url = urlComponets.url else {
            return nil
        }
        print(url)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        self.header.forEach {
            urlRequest.addValue($0, forHTTPHeaderField: $1)
        }
        
        return urlRequest
    }
}
