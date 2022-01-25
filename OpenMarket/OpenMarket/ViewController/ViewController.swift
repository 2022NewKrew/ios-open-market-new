//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // API Test
        APIManager.shared.fetchProductList(pageNo: 2, itemsPerPage: 5) { result in
            switch result {
            case .success(let page):
                print(page)
            case .failure(let error):
                print(error)
            }
        }

        APIManager.shared.fetchProduct(productId: 657) { result in
            switch result {
            case .success(let product):
                print(product)
            case .failure(let error):
                print(error)
            }
        }

        APIManager.shared.checkServer { result in
            switch result {
            case .success(let isAvailable):
                print(isAvailable)
            case .failure(let error):
                print(error)
            }
        }
    }


}

