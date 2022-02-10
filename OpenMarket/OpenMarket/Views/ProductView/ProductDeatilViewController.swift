//
//  ProductDeatilViewController.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/10.
//

import UIKit

class ProductDeatilViewController: UIViewController, ProductController, ModifyDelegate {

    private var productEditViewController: ProductEditViewController?
    weak var delegate: ModifyDelegate?
    var product: Product?
    
    private lazy var updateButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Update",
            style: .plain,
            target: self,
            action: #selector(self.pressUpdateButton(_:))
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.updateButton
    }

    @objc func pressUpdateButton(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: Constant.productEditSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as? ProductEditViewController
        destinationViewController?.product = self.product
        self.productEditViewController = destinationViewController
        self.productEditViewController?.delegate = self

        destinationViewController?.navigationTitle = "상품수정"
    }

    func modify() {
        DispatchQueue.main.async {
            self.delegate?.modify()
            self.navigationController?.popViewController(animated: true)
        }
    }

}
