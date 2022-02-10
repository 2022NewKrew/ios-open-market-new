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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var selectedImageIdx: Int?
    var mode: ModeState?
    var product: Product?
    var productId: Int?
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        return imagePicker
    }()
    
    var images: [UIImage?] = [] {
        didSet {
            imageCollectionView.reloadData()
        }
    }
    
    private lazy var flowlayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 110, height: 110)
        return layout
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mode?.setNavigationTitle()
        mode?.setupProductInfo()
        setupCollectionView()
        addTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotificationObserver()
    }
    
    // MARK: Action
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        guard let productInput = validateProductInput() else { return }
        mode?.doneAction(input: productInput)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?
                .cgRectValue else { return }
        scrollViewBottomConstraint.constant = keyboardFrame.height
    }
    
    @objc func keyboardWillClose(_ notification: Notification) {
        scrollViewBottomConstraint.constant = 0
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
        
    // MARK: Helpers
    func setMode(mode: Mode) {
        switch mode {
        case .add:
            self.mode = AddMode(self)
        case .edit:
            self.mode = EditMode(self)
        }
    }
    
    func setProductInfo() {
        productNameTextField.text = product?.name
        productPriceTextField.text = product?.price.description
        productStockTextField.text = product?.stock.description
        productCurrencySegment.selectedSegmentIndex = product?.currency == .usd ? 1 : 0
        discountedPriceTextField.text = product?.discountedPrice.description
        productDescriptionTextView.text = product?.description
        
        loadImages()
    }

    enum Mode {
        case add, edit
    }
}

private extension ProductEditViewController {
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
    
    func setupCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.collectionViewLayout = flowlayout
    }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    func registerKeyboardNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillClose), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func validateProductInput() -> ProductInput?{
        guard let name = productNameTextField.text,
              let descriptions = productDescriptionTextView.text,
              let priceString = productPriceTextField.text else { return nil }
        
        if name.count < 3 || name.count > 100 {
            return nil
        }
        
        if descriptions.count < 10 || descriptions.count > 1000 {
            return nil
        }
        
        guard let price = Double(priceString) else { return nil }
        
        let discountedPriceString = discountedPriceTextField.text?.replacingOccurrences(of: " ", with: "") == "" ? "0" : discountedPriceTextField.text
        guard let discountedPriceString = discountedPriceString ,let discountedPrice = Double(discountedPriceString) else { return nil }
        
        let stockString = productStockTextField.text?.replacingOccurrences(of:" ", with: "") == "" ? "0" : productStockTextField.text
        guard let stockString = stockString, let stock = Int(stockString) else { return nil }
        
        let currency: Currency = productCurrencySegment.selectedSegmentIndex == 1 ? .usd : .krw
        
        return ProductInput(name: name, descriptions: descriptions, price: price, currency: currency, discountedPrice: discountedPrice, stock: stock)
    }
}
