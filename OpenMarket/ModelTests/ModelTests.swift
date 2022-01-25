//
//  ModelTests.swift
//  ModelTests
//
//  Created by kakao on 2022/01/25.
//

import XCTest
@testable import OpenMarket

class ModelTests: XCTestCase {
    var apiManager: OpenMarketAPIManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        apiManager = OpenMarketAPIManager(urlSession: urlSession)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        apiManager = nil
    }
    
    func test_getOpenMarketPrdodcutList_success인경우() {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil) else {
                fatalError()
            }
            
            let mockJSONData = OpenMarketAPIMock.getOpenMarketProductListMock
            return (successResponse, mockJSONData)
        }
        
        let expectedResponse = GetOpenMarketProudctListResponse(
            pageNumber: 1,
            itemsPerPage: 2,
            totalCount: 777,
            offset: 0,
            limit: 20,
            products: [
                OpenMarketProduct(
                    id: 1139,
                    vendorId: 10,
                    name: "올",
                    thumbnailURLString: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/10/thumb/d1722afa7d9211ec9173330fdef73a0f.jpeg",
                    currency: .krw,
                    price: 88888.0,
                    description: nil,
                    bargainPrice: 82222.0,
                    discountedPrice: 6666.0,
                    stock: 6,
                    createdAt: "2022-01-25T00:00:00.00",
                    issuedAt: "2022-01-25T00:00:00.00",
                    images: nil
                ),
                OpenMarketProduct(
                    id: 1138,
                    vendorId: 3,
                    name: "계란김밥먹고싶다",
                    thumbnailURLString: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/6c29bd977d9011ec9173c95ca02b68fe.jpeg",
                    currency: .krw,
                    price: 5555.0,
                    description: nil,
                    bargainPrice: 5550.0,
                    discountedPrice: 5.0,
                    stock: 5,
                    createdAt: "2022-01-25T00:00:00.00",
                    issuedAt: "2022-01-25T00:00:00.00",
                    images: nil
                ),
            ],
            lastPage: 39,
            hasNext: true,
            hasPrev: false
        )
        
        let expectation = XCTestExpectation(description: "response")
        
        apiManager.getOpenMarketProductList(pageNumber: 1, itemsPerPage: 30) { result in
            guard let data = try? result.get() else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(data, expectedResponse)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_getOpenMarketProductDetail_success인경우() {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil) else {
                fatalError()
            }
            
            let mockJSONData = OpenMarketAPIMock.getDetailopenMarketProductMock
            return (successResponse, mockJSONData)
        }
        
        let expectedResponse = GetDetailOpenMarketProductResponse(
            id: 300,
            vendorId: 3,
            name: "99999Test Product",
            description: "desc",
            thumbnail: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/6a676f8575fa11ecabfa7164a3728cac.jpg",
            currency: .krw,
            price: 0.0,
            bargainPrice: 0.0,
            discountedPrice: 0.0,
            stock: 0,
            issuedAt: "2022-01-15T00:00:00.00",
            createdAt: "2022-01-15T00:00:00.00",
            images: [
                OpenMarketProduct.ProductImage(
                    id: 219,
                    urlString: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/origin/6a676f8575fa11ecabfa7164a3728cac.jpg",
                    thumbnailURLString: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/6a676f8575fa11ecabfa7164a3728cac.jpg",
                    succeed: true,
                    issuedAt: "2022-01-15T00:00:00.00")
            ],
            vendors: Vendor(
                name: "Vendor2",
                id: 3,
                createdAt: "2021-12-27T00:00:00.0",
                issuedAt: "2021-12-27T00:00:00.0"
            )
        )
        
        let expectation = XCTestExpectation(description: "response")
        
        apiManager.getOpenMarketProductDetail(productId: 300) { result in
            guard let data = try? result.get() else {
                XCTFail()
                return
            }
            XCTAssertEqual(data, expectedResponse)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
