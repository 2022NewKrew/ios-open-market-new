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
                "items_per_page": 20,
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
                    },
                    {
                        "id": 1137,
                        "vendor_id": 3,
                        "name": "flower",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/a751be047d8f11ec917377eaef78fc7d.jpeg",
                        "currency": "KRW",
                        "price": 1.0,
                        "bargain_price": 0.0,
                        "discounted_price": 1.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1136,
                        "vendor_id": 3,
                        "name": "Kimbab",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/f725f3217d8e11ec9173c9a4e14d99ca.jpeg",
                        "currency": "KRW",
                        "price": 100000.0,
                        "bargain_price": 99000.0,
                        "discounted_price": 1000.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1135,
                        "vendor_id": 23,
                        "name": "여러장",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/23/thumb/2c23e3267d8e11ec917301287a12e693.jpeg",
                        "currency": "KRW",
                        "price": 123.0,
                        "bargain_price": 0.0,
                        "discounted_price": 123.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1134,
                        "vendor_id": 3,
                        "name": "피자광고아님",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/0f7a64b37d8e11ec9173c359a5b36f65.jpeg",
                        "currency": "KRW",
                        "price": 5000.0,
                        "bargain_price": 5000.0,
                        "discounted_price": 0.0,
                        "stock": 0,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1133,
                        "vendor_id": 3,
                        "name": "땅값너무비싸",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/f0e49c107d8c11ec91739d807ddef284.jpeg",
                        "currency": "KRW",
                        "price": 5000.0,
                        "bargain_price": 5000.0,
                        "discounted_price": 0.0,
                        "stock": 0,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1132,
                        "vendor_id": 3,
                        "name": "크로플마시썽",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/ddcfecbd7d8b11ec917331b1b41109ea.jpeg",
                        "currency": "KRW",
                        "price": 5000.0,
                        "bargain_price": 4000.0,
                        "discounted_price": 1000.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1131,
                        "vendor_id": 3,
                        "name": "마이스타ㅋㅋ",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/1b56ebca7d8b11ec9173338db685f24b.jpeg",
                        "currency": "KRW",
                        "price": 5000.0,
                        "bargain_price": 5000.0,
                        "discounted_price": 0.0,
                        "stock": 0,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1130,
                        "vendor_id": 3,
                        "name": "맥주맥주",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/abec6df77d8a11ec9173df53b696ebff.jpeg",
                        "currency": "KRW",
                        "price": 5000.0,
                        "bargain_price": 5000.0,
                        "discounted_price": 0.0,
                        "stock": 0,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1129,
                        "vendor_id": 3,
                        "name": "딸기 다섯",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/93f469a47d8a11ec91739504d7749c8b.jpeg",
                        "currency": "KRW",
                        "price": 50.0,
                        "bargain_price": 40.0,
                        "discounted_price": 10.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1128,
                        "vendor_id": 6,
                        "name": "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/3adf63b17d8a11ec917367d586591e58.jpg",
                        "currency": "KRW",
                        "price": 1000.0,
                        "bargain_price": 900.0,
                        "discounted_price": 100.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1127,
                        "vendor_id": 6,
                        "name": "dkd,did;of,ddd",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/c3a7faee7d8911ec9173999f5a7eed4b.jpg",
                        "currency": "KRW",
                        "price": 1000.0,
                        "bargain_price": 1000.0,
                        "discounted_price": 0.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1126,
                        "vendor_id": 3,
                        "name": "피자피자",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/aa0af92b7d8911ec91737bf813f68511.jpeg",
                        "currency": "KRW",
                        "price": 10000.0,
                        "bargain_price": 9000.0,
                        "discounted_price": 1000.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1125,
                        "vendor_id": 6,
                        "name": "ssss",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/7afe4ba87d8911ec9173cb0507730108.jpg",
                        "currency": "KRW",
                        "price": 1000.0,
                        "bargain_price": 1000.0,
                        "discounted_price": 0.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1124,
                        "vendor_id": 6,
                        "name": "gggggg",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/61bd4c957d8911ec91734bae530ed29c.jpg",
                        "currency": "KRW",
                        "price": 1000.0,
                        "bargain_price": 1000.0,
                        "discounted_price": 0.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1123,
                        "vendor_id": 3,
                        "name": "딸기딸기",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/580ab1b27d8911ec9173d31a08851606.jpeg",
                        "currency": "KRW",
                        "price": 1000.0,
                        "bargain_price": 900.0,
                        "discounted_price": 100.0,
                        "stock": 10,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1122,
                        "vendor_id": 22,
                        "name": "123",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/22/thumb/c4cc24ff7d8811ec9173a35d34f4d744.png",
                        "currency": "KRW",
                        "price": 11111.0,
                        "bargain_price": 11000.0,
                        "discounted_price": 111.0,
                        "stock": 1,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1121,
                        "vendor_id": 6,
                        "name": "할인해볼래!",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/6/thumb/a30f0f3c7d8811ec9173d523258d3099.jpg",
                        "currency": "KRW",
                        "price": 1234.0,
                        "bargain_price": 1200.0,
                        "discounted_price": 34.0,
                        "stock": 333,
                        "created_at": "2022-01-25T00:00:00.00",
                        "issued_at": "2022-01-25T00:00:00.00"
                    },
                    {
                        "id": 1120,
                        "vendor_id": 22,
                        "name": "ㅇㅇㅇㅇ",
                        "thumbnail": "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/22/thumb/81fdf0e97d8811ec917347e63a42b5aa.png",
                        "currency": "KRW",
                        "price": 111.0,
                        "bargain_price": 110.0,
                        "discounted_price": 1.0,
                        "stock": 123,
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
