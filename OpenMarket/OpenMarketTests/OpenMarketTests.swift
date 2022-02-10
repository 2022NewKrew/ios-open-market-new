//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이승주 on 2022/01/25.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    let productListRepository = RepositoryInjection.injectProductListRepository()
    let productRepository = RepositoryInjection.injectProductRepository()

    func test_상품리스트_받아오기_성공() {
        let pageNumber = 1
        let itemPerPage = 10

        self.productListRepository.productList(pageNumber: pageNumber, itemsPerPage: itemPerPage) { [weak self] result in
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

        self.productRepository.product(productId: productId) { [weak self] result in
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

    func test_상품등록_성공() {
        let postProduct = PostProduct(
            name: "좋은 상품",
            descriptions: "넘 좋아요",
            price: 100,
            currency: "KRW",
            discountedPrice: 90,
            stock: 10,
            secret: Constant.secret
        )
        let image = UIImage(systemName: "pencil")
        let images = [image, image]

        self.productRepository.addProduct(postProduct: postProduct, productImages: images) { [weak self] result in
            switch result {
            case .success(let product):
                var result = true
                if product == nil {
                    result = false
                }
                XCTAssertEqual(result, true)
            case .failure(let error):
                XCTFail("상품등록: 네트워크에러")
            }
        }
        sleep(3)
    }

    func test_상품수정_성공() {
        let postProduct = PostProduct(
            name: "좋은 상품",
            descriptions: "넘 좋아요",
            price: 100,
            currency: "KRW",
            discountedPrice: 90,
            stock: 10,
            secret: Constant.secret
        )
        let image = UIImage(systemName: "pencil")
        let images = [image, image]

        self.productRepository.addProduct(postProduct: postProduct, productImages: images) { [weak self] result in
            switch result {
            case .success(let product):
                guard let product = product else { return }

                let id = product.id
                self?.productRepository.updateProduct(
                    productId: id,
                    postProduct: postProduct,
                    productImages: images, completion: { [weak self] result in
                        switch result {
                        case .success(let product):
                            var result = true
                            if product == nil {
                                result = false
                            }
                            XCTAssertEqual(result, true)
                        case .failure(let error):
                            XCTFail("상품수정: 네트워크에러")
                        }
                    })
            case .failure(let error):
                XCTFail("상품등록: 네트워크에러")
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
