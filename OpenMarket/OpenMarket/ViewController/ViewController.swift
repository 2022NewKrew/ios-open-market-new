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
        APIManager.shared.fetchProductList(pageNo: 2, itemsPerPage: 5) { page in
            print(page)
        }

        APIManager.shared.fetchProduct(productId: 657) { product in
            print(product)
        }

        APIManager.shared.checkServer { isAvailable in
            print(isAvailable)
        }
    }


}

