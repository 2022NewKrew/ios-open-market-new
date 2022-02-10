//
//  ProductEditViewController+State.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/09.
//

import UIKit

extension ProductEditViewController {
    class AddMode: ModeState {

        weak var master: ProductEditViewController?
        
        init(_ master: ProductEditViewController){
            self.master = master
        }
        
        func setupProductInfo() {
            master?.setProductInfo()
        }
        
        func setNavigationTitle() {
            master?.navigationBar.topItem?.title = "상품등록"
        }
        
        func doneAction(input: ProductInput) {
            guard let master = master else { return }
            APIManager.shared.postProduct(input: input, images: master.images.compactMap {$0}) { result in
                switch result{
                case .success(_):
                    print("post succeed")
                    DispatchQueue.main.async {
                        master.dismiss(animated: true, completion: nil)
                    }
                case .failure(_):
                    print("post failed")
                }
            }
        }
        
        func imageCount() -> Int {
            guard let master = master else { return 0 }
            return master.images.count < 5 ? master.images.count + 1 : master.images.count
        }
        
        func didSelectItem(index: Int) {
            guard let master = master else { return }
            master.selectedImageIdx = index
            master.present(master.imagePicker, animated: true)
        }
        
    }
    
    class EditMode: ModeState {

        weak var master: ProductEditViewController?
        
        init(_ master: ProductEditViewController){
            self.master = master
        }
        
        func setupProductInfo() {
            guard let master = master, let productId = master.productId else { return }
            APIManager.shared.fetchProduct(productId: productId) { result in
                switch result {
                case .success(let product):
                    master.product = product
                    DispatchQueue.main.async {
                        master.setProductInfo()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        func setNavigationTitle() {
            guard let master = master else { return }
            master.navigationBar.topItem?.title = "상품수정"
        }
        
        func doneAction(input: ProductInput) {
            guard let master = master, let productId = master.productId else { return }
            APIManager.shared.updateProduct(productId: productId ,input: input) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        master.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        func imageCount() -> Int {
            master?.images.count ?? 0
        }
        
        func didSelectItem(index: Int) {
            return
        }
    }
}
