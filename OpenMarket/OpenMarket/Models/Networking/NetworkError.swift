//
//  NetworkError.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case transportError
    case responseError
    case networkFailure(statusCode: Int)
    case missingData
    case decodingError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다"
        case .transportError:
            return "서버로 데이터를 보내는 과정에서 오류가 발생했습니다"
        case .responseError:
            return "서버로부터 응답을 받지 못했습니다"
        case .networkFailure(let statusCode):
            return "\(statusCode) 서버와의 통신에 실패했습니다"
        case .missingData:
            return "데이터가 유실되었습니다"
        case .decodingError:
            return "디코딩 오류"
        }
    }
}
