//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/08.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var product: OpenMarketProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupUI()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard self.product != nil else {
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ProductManagingViewController,
        let product = self.product else {
            return
        }
        destination.kind = .modification(product: product)
    }
    
    private func setup() {
        self.setupRightBarManageButtonItem()
    }
    
    private func setupUI() {
        guard let productName = self.product?.name else {
            return
        }
        self.title = productName
    }
    
    private func setupRightBarManageButtonItem() {
        guard let vendorId = self.product?.vendorId, vendorId == APIConstants.vendorIntId else {
            return
        }
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: ManagingConstants.manageButtonSystemImageName),
            style: .plain,
            target: self,
            action: #selector(self.showAlert)
        )
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func showAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(
            title: ManagingConstants.updateActionTitle,
            style: .default
        ) { _ in
            self.performSegue(withIdentifier: ManagingConstants.modifySegueIdentifier, sender: nil)
        }
        let deleteAction = UIAlertAction(
            title: ManagingConstants.deleteActionTitle,
            style: .destructive
        ) { _ in
            
        }
        let cancelAction = UIAlertAction(
            title: ManagingConstants.cancelActionTitle,
            style: .cancel
        )
        alert.addAction(updateAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
}
