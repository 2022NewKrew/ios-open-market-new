//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let manager = OpenMarketAPIManager()
        manager.getOpenMarketProductList(pageNumber: 1, itemsPerPage: 1, completion: { result in
            print("#list",result)
        })
        
        manager.getOpenMarketProductDetail(productId: 300, completion: { result in
            print("#detail",result)
        })
    }


}

