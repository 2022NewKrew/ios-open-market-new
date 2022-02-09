//
//  APIConstants.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//
import Foundation

struct APIConstants {
    static let baseURL = "https://market-training.yagom-academy.kr/api"
    static let productsEndPoint = "products"
    static let pageNo = "page_no"
    static let itemsPerPage = "items_per_page"
    static let productId = "product_id"
    static let identifier = "identifier"
    static let vendorIdentifier = "aa848b00-7217-11ec-abfa-0933567519e0"
    static let vendorIntId = 36
    static let vendorPassword = "Jq_xu-7-N_5#!*ET"
    static let params = "params"
    static let images = "images"
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
}

enum ContentType {
    case json
    case multiPartForm(boundary: String)
    
    var value: String {
        switch self {
        case .json:
            return "application/json"
        case .multiPartForm(let boundary):
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
}

enum MultipartFromDataConstants {
    case boundaryPrefix(boundary: String, isLast: Bool = false)
    case contentDispositionOfText(name: String)
    case contentDispositionOfFile(name: String, fileName: String)
    case contentTypeOfFile(mimeType: String = "image/jpg")
    case lineBreak
    
    var value: String {
        switch self {
        case .boundaryPrefix(let boundary, let isLast):
            if isLast {
                return "--\(boundary)--\r\n"
            }
            return "--\(boundary)\r\n"
            
        case .contentDispositionOfText(let name):
            return "Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n"
            
        case .contentDispositionOfFile(let name, let fileName):
            return "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n"
            
        case .contentTypeOfFile(let mimeType):
            return "Content-Type: \(mimeType)\r\n\r\n"
            
        case .lineBreak:
            return "\r\n"
        }
    }
}

enum HTTPMethod: String {
    case post = "POST"
    case `get` = "GET"
    case patch = "PATCH"
    case delete = "DELETE"
}
