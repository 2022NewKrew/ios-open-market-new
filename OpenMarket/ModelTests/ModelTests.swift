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
        
        let expectedResponse = OpenMarketAPIMock.expectedOpenMarketProductListGetResponse
        
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
        
        let expectedResponse = OpenMarketAPIMock.expectedOpenMarketProductDetailGetResponse
        
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
