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
    @IBOutlet weak var textViewbottomConstraint: NSLayoutConstraint!
    
    var keyboardHeight: CGFloat?
    var activeField: UITextField?
    
    var selectedImageIdx: Int?
    var mode: Mode?
    var product: Product?
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private var images: [UIImage?] = [] {
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
        setNavigationBarTitle()
        setProductInfo()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.collectionViewLayout = flowlayout
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
     //   view.addGestureRecognizer(tapGesture)
        productDescriptionTextView.delegate = self

    }
    
    // MARK: Action
    @IBAction func cancelAction(_ sender: Any) {
        // cancel action
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        // done action
        switch mode {
        case .add:
            addProduct()
        case .edit:
            break
        case .none:
            break
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardHeight = keyboardFrame.height
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
        
    // MARK: Helpers
    private func addProduct(){
        guard let name = productNameTextField.text,
              let descriptions = productDescriptionTextView.text,
              let priceString = productPriceTextField.text,
              let price = Double(priceString),
              let discountedPriceString = discountedPriceTextField.text,
              let discountedPrice = Double(discountedPriceString),
              let stockString = productStockTextField.text,
              let stock = Int(stockString) else { return }
        let currency: Currency = productCurrencySegment.selectedSegmentIndex == 1 ? .usd : .krw
        
        APIManager.shared.addProduct(name: name, descriptions: descriptions, price: price, currency: currency, discountedPrice: discountedPrice, stock: stock, images: images.compactMap {$0}) { result in
            switch result{
            case .success(_):
                print("post succeed")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(_):
                print("post failed")
            }
        }
    }
    
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
    
    private func scrollToCursorPositionIfBelowKeyboard() {
        guard let keyboardHeight = keyboardHeight else { return }
        let caret = productDescriptionTextView.caretRect(for: productDescriptionTextView.selectedTextRange!.start)
        let textViewY = productDescriptionTextView.frame.origin.y
        let caretY = caret.origin.y + textViewY
        let keyboardTopBorder = view.frame.height - keyboardHeight

       // Remember, the y-scale starts in the upper-left hand corner at "0", then gets
       // larger as you go down the screen from top-to-bottom. Therefore, the caret.origin.y
       // being larger than keyboardTopBorder indicates that the caret sits below the
       // keyboardTopBorder, and the textView needs to scroll to the position.
       if caretY > keyboardTopBorder {
           print("OVER")
        //   view.frame.origin.y -= view.frame.origin.y == 0 ? keyboardHeight : 0
          
        }
     }
    
    enum Mode{
        case add,edit
    }
    
    var borrr = false
}

extension ProductEditViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count < 5 && mode == .add ? images.count + 1 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == images.count && images.count < 5 && mode == .add {
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "LastImageCell", for: indexPath)
            return cell
        } else {
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
            cell.setImage(images[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        selectedImageIdx = indexPath.row
        present(imagePicker, animated: true)
    }
}

extension ProductEditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
  //      scrollToCursorPositionIfBelowKeyboard()
   //     scrollView.scrollRectToVisible(textView.frame, animated: true)
//        if !borrr {
//            textViewbottomConstraint.constant = -keyboardHeight!
//        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    //    scrollToCursorPositionIfBelowKeyboard()
    //    scrollView.scrollRectToVisible(textView.frame, animated: true)
//        if !borrr {
//            textViewbottomConstraint.constant = -keyboardHeight!
//        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollView.setContentOffset(.zero, animated: true)
    }
}

extension ProductEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let newImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let selectedImageIdx = selectedImageIdx,
              mode == .add
            else {
                picker.dismiss(animated: true, completion: nil)
                return
            }
        if images.count > selectedImageIdx {
            images[selectedImageIdx] = newImage
        } else {
            images.append(newImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
                                 
                                 

