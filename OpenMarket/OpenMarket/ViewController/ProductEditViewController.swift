//
//  ProductEditViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//

import UIKit

class ProductEditViewController: UIViewController {

    // MARK: IBOutlets & Variables
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productCurrencySegment: UISegmentedControl!
    @IBOutlet weak var discountedPriceTextField: UITextField!
    @IBOutlet weak var productStockTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var mode: Mode?
    var product: Product?
    private var images: [UIImage?] = [] {
        didSet {
            imageCollectionView.reloadData()
        }
    }
    
    private lazy var flowlayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 110, height: 110)
        return layout
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTitle()
        setProductInfo()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.collectionViewLayout = flowlayout
    }
    
    // MARK: Action
    @IBAction func cancelAction(_ sender: Any) {
        // cancel action
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        // done action
    }
        
    // MARK: Helpers
    private func setNavigationBarTitle(){
        if let mode = mode {
            switch mode {
            case .add:
                navigationBar.topItem?.title = "상품등록"
            case .edit:
                navigationBar.topItem?.title = "상품수정"
            }
        }
    }
    
    private func setProductInfo() {
        productNameTextField.text = product?.name
        productPriceTextField.text = product?.price.description
        productStockTextField.text = product?.stock.description
        productCurrencySegment.selectedSegmentIndex = product?.currency == .usd ? 1 : 0
        discountedPriceTextField.text = product?.discountedPrice.description
        productDescriptionTextView.text = product?.description
        
        loadImages()
    }
    
    private func loadImages() {
        guard let product = product, let images = product.images else { return }
        self.images = [UIImage?](repeating: nil, count: images.count)
        for (idx, image) in images.enumerated() {
            guard let imageURL = image.imageUrl else { return }
            ImageCache.shared.load(url: imageURL as NSURL) { productImage in
                self.images[idx] = productImage
            }
        }
    }

    enum Mode{
        case add,edit
    }
}

extension ProductEditViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count > 5 ? images.count : images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == images.count && images.count < 5 {
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "LastImageCell", for: indexPath)
            return cell
        } else {
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
            cell.setImage(images[indexPath.row])
            return cell
        }
    }
    
}
