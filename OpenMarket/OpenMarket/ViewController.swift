//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Connector.shared.get(from: "api/products?page_no=1&items_per_page=10")
        // Do any additional setup after loading the view.
    }


}

