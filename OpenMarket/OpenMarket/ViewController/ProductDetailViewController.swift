//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/10.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var imageCountLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productStockLabel: UILabel!
    @IBOutlet weak var productDiscountedLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UITextView!
    
    var productId: Int?
    lazy var currentPage: Int = 0 {
        didSet {
            imageCountLabel.text = "\(currentPage + 1) / \(images.count)"
        }
    }
    
    var images: [UIImage?] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var product: Product? {
        didSet {
            DispatchQueue.main.async {
                self.setProductInfo()
            }
        }
    }
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width, height: 300)
        return layout
    }()
    
    private lazy var actionBarButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonClicked))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = actionBarButton
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.isPagingEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let productId = productId else { return }
        APIManager.shared.fetchProduct(productId: productId) { result in
            switch result {
            case .success(let product):
                self.product = product
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func actionButtonClicked() {
        let actionSheetAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(title: "수정", style: .default) { _ in
            self.updateProduct()
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.deleteProduct()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheetAlertController.addAction(updateAction)
        actionSheetAlertController.addAction(deleteAction)
        actionSheetAlertController.addAction(cancelAction)
        
        present(actionSheetAlertController, animated: true, completion: nil)
    }
    
    func updateProduct() {
        guard let productEditViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "ProductEditVC") as? ProductEditViewController else { return }
        productEditViewController.modalPresentationStyle = .fullScreen
        productEditViewController.setMode(mode: .edit)
        productEditViewController.productId = productId
        present(productEditViewController, animated: true, completion: nil)
    }
    
    func deleteProduct() {
        let alertController = UIAlertController(title: "삭제", message: "비밀번호를 입력하세요.", preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.placeholder = "비밀번호"
        }
        
        let okAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            guard let password = alertController.textFields?[0].text,
                  let productId = self.productId
            else { return }
            self.fetchProductSecretKey(productId: productId) { secretKey in
                guard password == secretKey else { return }
                APIManager.shared.deleteProduct(productId: productId, secretKey: secretKey) { result in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchProductSecretKey(productId: Int, completion: @escaping (String) -> Void){
        APIManager.shared.fetchProductSecretKey(productId: productId) { result in
            switch result {
            case .success(let secretKey):
                completion(secretKey)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setProductInfo(){
        guard let product = product else { return }
        
        self.title = product.name
        
        productNameLabel.text = product.name
        
        if product.discountedPrice != 0 {
            let text = "\(product.currency.rawValue) \(product.price)"
            productDiscountedLabel.isHidden = false
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            productDiscountedLabel.attributedText = attributeString
        }
        
        productPriceLabel.text = "\(product.currency.rawValue) \(product.price - product.discountedPrice)"
        
        productStockLabel.textColor = product.stock == 0 ? .systemOrange : .lightGray
        productStockLabel.text = product.stock == 0 ? "품절" : "잔여수량: \(product.stock)"
        productDescriptionLabel.text = product.description
        guard let productImages = product.images else {
            imageCountLabel.isHidden = true
            return
        }

        imageCountLabel.text = "\(currentPage + 1) / \(productImages.count)"

        loadImages()
    }
    
    func loadImages() {
        guard let product = product, let images = product.images else { return }
        self.images = [UIImage?](repeating: nil, count: images.count)
        for (idx, image) in images.enumerated() {
            guard let imageURL = image.imageUrl else { return }
            ImageCache.shared.load(url: imageURL as NSURL) { productImage in
                DispatchQueue.main.async {
                    self.images[idx] = productImage
                }
            }
        }
    }
}

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
        cell.setImage(images[indexPath.row])
        return cell
    }
}

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            if let cv = scrollView as? UICollectionView {
                let layout = cv.collectionViewLayout as! UICollectionViewFlowLayout
                let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
                let offset = targetContentOffset.pointee
                let idx = Int(round((offset.x + cv.contentInset.left) / cellWidth))
                
                if idx > currentPage {
                    currentPage += 1
                } else if idx < currentPage {
                    if currentPage != 0 {
                        currentPage -= 1
                    }
                }
            }
        }
}
