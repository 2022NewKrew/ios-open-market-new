//
//  ProductListRepository.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/01/25.
//

import UIKit

protocol ProductListRepository {
    func productList(pageNumber: Int, itemsPerPage: Int , completion: @escaping (Result<ProductList?, NetworkError>) -> Void)
    func image(url: URL, completion: @escaping (Data) -> Void)
}
