//
//  OpenMarketAPIMock.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/25.
//

import Foundation

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
}
