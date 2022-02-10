//
//  OpenMarketAPIMock.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation
@testable import OpenMarket

enum OpenMarketAPIMock {
    static let getDetailopenMarketProductMock: Data = Data(
            """
            {
                "id": 300,
                "vendor_id": 3,
                "name": "99999Test Product",
                "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/6a676f8575fa11ecabfa7164a3728cac.jpg",
                "currency": "KRW",
                "price": 0.0,
                "description": "desc",
                "bargain_price": 0.0,
                "discounted_price": 0.0,
                "stock": 0,
                "created_at": "2022-01-15T00:00:00.00",
                "issued_at": "2022-01-15T00:00:00.00",
                "images": [
                    {
                        "id": 219,
                        "url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/origin/6a676f8575fa11ecabfa7164a3728cac.jpg",
                        "thumbnail_url": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/6a676f8575fa11ecabfa7164a3728cac.jpg",
                        "succeed": true,
                        "issued_at": "2022-01-15T00:00:00.00"
                    }
                ],
                "vendors": {
                    "name": "Vendor2",
                    "id": 3,
                    "created_at": "2021-12-27T00:00:00.00",
                    "issued_at": "2021-12-27T00:00:00.00"
                }
            }
            """.utf8
    )
    
    static let getOpenMarketProductListMock: Data = Data(
            """
            {
                "page_no": 1,
                "items_per_page": 2,
                "total_count": 777,
                "offset": 0,
                "limit": 20,
                "pages": [
                    {
                        "id": 1139,
                        "vendor_id": 10,
                        "name": "올",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/10/thumb/d1722afa7d9211ec9173330fdef73a0f.jpeg",
                        "currency": "KRW",
                        "price": 88888.0,
                        "bargain_price": 82222.0,
                        "discounted_price": 6666.0,
                        "stock": 6,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1138,
                        "vendor_id": 3,
                        "name": "계란김밥먹고싶다",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/6c29bd977d9011ec9173c95ca02b68fe.jpeg",
                        "currency": "KRW",
                        "price": 5555.0,
                        "bargain_price": 5550.0,
                        "discounted_price": 5.0,
                        "stock": 5,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    }
                ],
                "last_page": 39,
                "has_next": true,
                "has_prev": false
            }
            """.utf8
    )
    
    static let expectedOpenMarketProductListGetResponse = OpenMarketProudctListResponse(
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
    
    static let expectedOpenMarketProductDetailGetResponse = OpenMarketProductResponse(
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
            createdAt: "2021-12-27T00:00:00.00",
            issuedAt: "2021-12-27T00:00:00.00"
        )
    )
}
