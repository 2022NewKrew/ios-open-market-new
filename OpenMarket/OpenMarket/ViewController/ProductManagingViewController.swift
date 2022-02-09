//
//  ProductRegisterationViewController.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/03.
//

import UIKit

class ProductManagingViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fifthImageView: UIImageView!
    @IBOutlet weak var productNameTextField: ProductInfoTextField!
    @IBOutlet weak var priceTextField: ProductInfoTextField!
    @IBOutlet weak var discountedPriceTextField: ProductInfoTextField!
    @IBOutlet weak var stockTextField: ProductInfoTextField!
    @IBOutlet weak var currencySegementedControl: UISegmentedControl!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var keyboardHeightConstraint: NSLayoutConstraint!
    
    enum Kind: Equatable {
        case registeration
        case modification(product: OpenMarketProduct)
    }
    
    enum CurrecncySegmentedControlValue: Int {
        case krw
        case usd
    }
    
    enum ImageManagingType {
        case add
        case update(index: Int)
        case delete(index: Int)
    }
    
    var kind: Kind = .registeration
    private let apiManager = OpenMarketAPIManager()
    private let picker = UIImagePickerController()
    private let emptyImageAlertController: UIAlertController = {
        let alert = UIAlertController(
            title: Constants.emptyImageAlertTitle,
            message: Constants.emptyImageAlertMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: Constants.okActionTitle,
            style: .default
        )
        alert.addAction(okAction)
        return alert
    }()
    private let fullImageAlertController: UIAlertController = {
        let alert = UIAlertController(
            title: Constants.fullImageAlertTitle,
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: Constants.okActionTitle,
            style: .default
        )
        alert.addAction(okAction)
        return alert
    }()
    private var keyboardHeight: CGFloat = 0.0
    private var imageManagingType: ImageManagingType = .add
    var images: Images = Images(maxImageCount: 5)
    
    private lazy var imageViews: [UIImageView] = {
        return [
            self.firstImageView,
            self.secondImageView,
            self.thirdImageView,
            self.fourthImageView,
            self.fifthImageView
        ]
    }()
    
    private lazy var textFields: [ProductInfoTextField] = {
        return [
            self.productNameTextField,
            self.priceTextField,
            self.discountedPriceTextField,
            self.stockTextField
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImagePickerViewController()
        self.setup()
        self.setupUI()
    }
    
    private func setupImagePickerViewController() {
        self.picker.sourceType = .photoLibrary
        self.picker.delegate = self
        self.picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum),
           let mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)?.filter({
               $0.contains("image")
           }) {
            self.picker.mediaTypes = mediaTypes
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary),
           let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)?.filter({
               $0.contains("image")
           }) {
            self.picker.mediaTypes = mediaTypes
        }
    }
    
    private func setup() {
        self.addGestureRecognizerForImageViews()
        self.setupDelegates()
        self.setupKeyboard()
    }
    
    private func setupUI() {
        self.productNameTextField.keyboardType = .default
        self.priceTextField.keyboardType = .numberPad
        self.discountedPriceTextField.keyboardType = .numberPad
        self.stockTextField.keyboardType = .numberPad
        self.descriptionTextView.keyboardType = .default
        
        self.descriptionTextView.text = Constants.productDescriptionTextViewPlaceholder
        self.descriptionTextView.textColor = .lightGray
        
        switch self.kind {
        case .registeration:
            self.title = Constants.productRegisterationTitle
        case .modification(let product):
            self.title = Constants.productModificationTitle
            self.addImageButton.isHidden = true
            guard let imageInfos = product.images else {
                return
            }
            let imageURLs = imageInfos.map{ $0.urlString }
            imageURLs.enumerated().forEach { (i,urlString) in
                ImageLoader.loadImage(urlString: urlString) { image in
                    self.imageViews[i].isHidden = false
                    self.imageViews[i].image = image
                }
            }
            self.productNameTextField.text = product.name
            self.priceTextField.text = String(product.price)
            self.discountedPriceTextField.text = String(product.discountedPrice)
            self.stockTextField.text = String(product.stock)
            self.descriptionTextView.text = product.description
            self.descriptionTextView.textColor = .black
        }
    }
    
    private func addGestureRecognizerForImageViews() {
        guard self.kind == .registeration else {
            return
        }
        self.imageViews.forEach { imageView in
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.showImageManagingMenu))
            imageView.addGestureRecognizer(tapGestureRecognizer)
            imageView.isUserInteractionEnabled = true
        }
    }
    
    private func setupDelegates() {
        self.productNameTextField.delegate = self
        self.priceTextField.delegate = self
        self.discountedPriceTextField.delegate = self
        self.stockTextField.delegate = self
        self.descriptionTextView.delegate = self
    }
    
    private func setupKeyboard() {
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.scrollView.addGestureRecognizer(touch)
        self.addKeyboardNotifications()
    }
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func scrollToMakeTextViewCursorVisible(in textView: UITextView, rate: CGFloat = 0.25) {
        guard textView.isFirstResponder,
              let selectedTextRange = textView.selectedTextRange else {
                  return
              }
        
        let caretRect = textView.caretRect(for: selectedTextRange.start)
        let rectFromView = textView.convert(caretRect, to: self.view)
        
        self.adjustContentOffsetToMakeRectVisibleAboveKeyboard(target: rectFromView, rate: rate)
    }
    
    private func adjustContentOffsetToMakeRectVisibleAboveKeyboard(target: CGRect, rate: CGFloat = 0.25) {
        let targetBottomY = target.origin.y + target.size.height
        let keyboardTopY = self.view.frame.height - self.keyboardHeight
        
        if keyboardTopY < targetBottomY {
            let difference = targetBottomY - keyboardTopY
            let newOffset = CGPoint(x: self.scrollView.contentOffset.x, y: self.scrollView.contentOffset.y + difference + 10)
            UIView.animate(withDuration: rate) {
                self.scrollView.contentOffset = newOffset
                self.keyboardHeightConstraint.constant = self.keyboardHeight
            }
        }
    }
    
    private func validateImages() -> Bool {
        if self.kind != .registeration {
            return true
        }
        
        if self.images.isEmpty {
            self.present(self.emptyImageAlertController, animated: true)
            return false
        }
        return true
    }
    
    @discardableResult
    private func validateTextField(textField: UITextField) -> Bool {
        guard let textField = textField as? ProductInfoTextField else {
            return false
        }
        
        guard let text = textField.text else {
            textField.isValidate = false
            return false
        }
        
        var result = true
        
        switch textField {
        case self.productNameTextField:
            if text.isEmpty {
                result = false
            }
        case self.priceTextField, self.discountedPriceTextField:
            if Float(text) == nil {
                result = false
            }
        case self.stockTextField:
            if Int(text) == nil {
                result = false
            }
        default: result = false
        }
        
        textField.isValidate = result
        return result
    }
    
    @discardableResult
    private func validateTextView(textview: UITextView) -> Bool {
        guard let text = textview.text, text.isNotEmtpy, text != Constants.productDescriptionTextViewPlaceholder else {
            textview.textColor = UIColor.systemOrange
            return false
        }
        return true
    }
    
    private func validateUserInput() -> Bool {
        var isValidate = true
        self.textFields.forEach { textField in
            if !self.validateTextField(textField: textField) {
                isValidate = false
            }
        }
        if !self.validateTextView(textview: self.descriptionTextView) {
            isValidate = false
        }
        if !self.validateImages() {
            isValidate = false
        }
        return isValidate
    }
    
    private func createOpenMarketProductParam(productName: String, description: String, price: Int, currency: OpenMarketProduct.Currency, discountedPrice: Float, stock: Int) -> OpenMarketProductPostParam {
        let openMarketProductPostParam = OpenMarketProductPostParam(
            name: productName,
            descriptions: description,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: APIConstants.vendorPassword
        )
        return openMarketProductPostParam
    }
    
    private func createOpenMarketProductPatchParam(productName: String, description: String, price: Int, currency: OpenMarketProduct.Currency, discountedPrice: Float, stock: Int, thumbnailId: Int) -> OpenMarketProductPatchParam {
        let openMarketProductPatchParam = OpenMarketProductPatchParam(
            name: productName,
            descriptions: description,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: APIConstants.vendorPassword,
            thumbnailId: thumbnailId
        )
        return openMarketProductPatchParam
    }
    
    private func findImageViewIndex(target: UIImageView) -> Int? {
        return self.imageViews.firstIndex { imageView in
            target == imageView
        }
    }
    
    private func addNewImage(image: UIImage) {
        if self.images.addImage(image) {
            let index = self.images.count - 1
            self.imageViews[index].image = image
            self.imageViews[index].isHidden = false
        }
    }
    
    private func updateImage(image: UIImage, at index: Int) {
        if self.images.updateImage(image, at: index) {
            self.imageViews[index].image = image
        }
    }
    
    private func deleteImage(at index: Int) {
        if self.images.deleteImage(at: index) {
            let images = self.images.images
            let count = self.images.count
            for i in 0 ..< self.images.maxImageCount {
                self.imageViews[i].image = nil
                self.imageViews[i].isHidden = true
                if i < count {
                    self.imageViews[i].image = images[i]
                    self.imageViews[i].isHidden = false
                }
            }
        }
    }
    
    private func postOpenMarketProduct(productName: String, description: String, price: Int, currency: OpenMarketProduct.Currency, discountedPrice: Float, stock: Int, completion: @escaping (Result<OpenMarketProudctPostOrPatchResponse, Error>) -> Void) {
        let param = self.createOpenMarketProductParam(
            productName: productName,
            description: description,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock
        )
        
        self.apiManager.postOpenMarketProduct(
            identifier: APIConstants.vendorIdentifier,
            params: param,
            images: self.images.images
        ) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func patchOpenMarketProduct(productName: String, description: String, price: Int, currency: OpenMarketProduct.Currency, discountedPrice: Float, stock: Int, productId: Int, thumbnailId: Int, completion: @escaping (Result<OpenMarketProudctPostOrPatchResponse, Error>) -> Void) {
        let param = self.createOpenMarketProductPatchParam(
            productName: productName,
            description: description,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            thumbnailId: thumbnailId
        )
        
        self.apiManager.patchOpenMarketProduct(
            identifier: APIConstants.vendorIdentifier,
            productId: productId,
            params: param
        ) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    @objc func showImageManagingMenu(sender: UITapGestureRecognizer) {
        let target = sender.view
        guard let imageView = target as? UIImageView,
              let index = self.findImageViewIndex(target: imageView) else {
                  return
              }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(
            title: Constants.updateActionTitle,
            style: .default
        ) { _ in
            self.imageManagingType = .update(index: index)
            self.present(self.picker, animated: true)
        }
        let deleteAction = UIAlertAction(
            title: Constants.deleteActionTitle,
            style: .destructive
        ) { _ in
            self.deleteImage(at: index)
        }
        let cancelAction = UIAlertAction(
            title: Constants.cancelActionTitle,
            style: .cancel
        )
        alert.addAction(updateAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRect = keyboardFrame.cgRectValue
        self.keyboardHeight = keyboardRect.height
        
        let rate = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        
        guard let firstResponder = self.view.firstResponder else { return }
        if firstResponder == self.descriptionTextView {
            self.scrollToMakeTextViewCursorVisible(in: self.descriptionTextView, rate: rate)
            return
        }
        
        let firstResponderRectFromSuperView = firstResponder.convert(firstResponder.bounds, to: self.view)
        self.adjustContentOffsetToMakeRectVisibleAboveKeyboard(target: firstResponderRectFromSuperView, rate: rate)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let rate = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        self.keyboardHeightConstraint.constant = 0
        UIView.animate(withDuration: rate) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissKeyboard(_ tapGesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        if self.images.isFull {
            self.present(self.fullImageAlertController, animated: true)
        }
        self.imageManagingType = .add
        self.present(self.picker, animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        self.view.endEditing(true)
        guard self.validateUserInput() else {
            return
        }
        
        let selectedCurrencyIndex = self.currencySegementedControl.selectedSegmentIndex
        let currency: OpenMarketProduct.Currency = selectedCurrencyIndex == CurrecncySegmentedControlValue.krw.rawValue ? .krw : .usd
        
        guard let productName = self.productNameTextField.text,
              let description = self.descriptionTextView.text,
              let priceText = self.priceTextField.text, let price = Int(priceText),
              let discountedPriceText = self.discountedPriceTextField.text, let discountedPrice = Float(discountedPriceText),
              let stockText = self.stockTextField.text, let stock = Int(stockText) else {
                  return
              }
        
        switch self.kind {
        case .registeration:
            self.postOpenMarketProduct(
                productName: productName,
                description: description,
                price: price,
                currency: currency,
                discountedPrice: discountedPrice,
                stock: stock
            ) { result in
                if let _ = try? result.get() {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        case .modification(let product):
            guard let productId = product.id,
                  let imageInfos = product.images,
                  let thumbnailURLString = product.thumbnailURLString,
                  let thumbnailId = imageInfos.filter({
                      $0.thumbnailURLString == thumbnailURLString
                  }).first?.id else {
                      return
                  }
            self.patchOpenMarketProduct(
                productName: productName,
                description: description,
                price: price, currency: currency,
                discountedPrice: discountedPrice,
                stock: stock,
                productId: productId,
                thumbnailId: thumbnailId
            ) { result in
                if let _ = try? result.get() {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProductManagingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.25) {
            switch textField {
            case self.productNameTextField:
                self.priceTextField.becomeFirstResponder()
            case self.priceTextField:
                self.discountedPriceTextField.becomeFirstResponder()
            case self.discountedPriceTextField:
                self.stockTextField.becomeFirstResponder()
            case self.stockTextField:
                self.descriptionTextView.becomeFirstResponder()
            default: break
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.validateTextField(textField: textField)
    }
}

extension ProductManagingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.scrollToMakeTextViewCursorVisible(in: textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.productDescriptionTextViewPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constants.productDescriptionTextViewPlaceholder
        }
        self.validateTextView(textview: textView)
    }
}

extension ProductManagingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            self.picker.dismiss(animated: true)
            return
        }
        switch self.imageManagingType {
        case .add:
            self.addNewImage(image: image)
        case .update(let index):
            self.updateImage(image: image, at: index)
        default: break
        }
        self.picker.dismiss(animated: true)
    }
}
