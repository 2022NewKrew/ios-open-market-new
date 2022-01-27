//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이승주 on 2022/01/25.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    let projectListRepository = RepositoryInjection.injectProductListRepository()
    let projectRepository = RepositoryInjection.injectProductRepository()

    func test_상품리스트_받아오기_성공() {
        let pageNumber = 1
        let itemPerPage = 10

        self.projectListRepository.productList(pageNumber: pageNumber, itemPerPage: itemPerPage) { result in
            switch result {
            case .success(let productList):
                var result = true
                if productList == nil {
                    result = false
                }
                XCTAssertEqual(result, true)
            case .failure(let error):
                XCTFail("상품리스트 받아오기: 네트워크에러")
            }
        }
        sleep(3)
    }

    func test_상품_받아오기_성공() {
        let productId = 522

        self.projectRepository.product(productId: productId) { result in
            switch result {
            case .success(let product):
                var result = true
                if product == nil {
                    result = false
                }
                XCTAssertEqual(result, true)
            case .failure(let error):
                XCTFail("상품리스트 받아오기: 네트워크에러")
            }
        }
        sleep(3)
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }


}
