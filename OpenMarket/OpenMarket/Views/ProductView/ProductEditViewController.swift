//
//  ProductEditViewController.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/02.
//

import UIKit

protocol ProductController: AnyObject {
    var delegate: ModifyDelegate? { get set }
}

protocol ModifyDelegate: AnyObject {
    func modify()
}

class ProductEditViewController: UIViewController, ProductController {

    var navigationTitle: String?
    var product: Product?
    var productImages: [UIImage?] = []
    var postProduct: PostProduct?
    weak var delegate: ModifyDelegate?
    private var productViewModel = ProductViewModel()
    private var registrationImageViewCount = 0
    private lazy var registrationImageViewArray = [
        registrationImageView1,
        registrationImageView2,
        registrationImageView3,
        registrationImageView4,
        registrationImageView5
    ]

    private lazy var registrationImageView1: UIImageView = self.createRegistrationImageView()
    private lazy var registrationImageView2: UIImageView = self.createRegistrationImageView()
    private lazy var registrationImageView3: UIImageView = self.createRegistrationImageView()
    private lazy var registrationImageView4: UIImageView = self.createRegistrationImageView()
    private lazy var registrationImageView5: UIImageView = self.createRegistrationImageView()
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        button.backgroundColor = .systemGray5
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(self.pressAddImageButton(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var registrationImageStackView: BaseStackView = {
        let stackView = BaseStackView(arrangedSubviews: [
            self.registrationImageView1,
            self.registrationImageView2,
            self.registrationImageView3,
            self.registrationImageView4,
            self.registrationImageView5,
            self.addImageButton
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = CGFloat(10)
        stackView.alignment = .trailing
        return stackView
    }()
    private lazy var registrationImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()

    private lazy var productNameTextField: UITextField = self.createProductTextField(placeholer: Constant.productNameTextFieldPlaceholder)
    private lazy var productOriginPriceTextField: UITextField = self.createProductTextField(placeholer: Constant.productOriginPriceTextFieldPlaceholder)
    private lazy var productPriceSegmentControl: UISegmentedControl = {
        let segmentControl: UISegmentedControl = UISegmentedControl(items: [NSString("KRW"), NSString("USD")])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(self.changeProductPriceSegmentControl(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    private lazy var productOriginPriceStackView: BaseStackView = {
        let stackView = BaseStackView(arrangedSubviews: [
            self.productOriginPriceTextField,
            self.productPriceSegmentControl
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = CGFloat(10)
        stackView.alignment = .center
        return stackView
    }()
    private lazy var productDiscountedPriceTextField: UITextField = self.createProductTextField(placeholer: Constant.productDiscountedPriceTextFieldPlaceholder)
    private lazy var productStockTextField: UITextField = self.createProductTextField(placeholer: Constant.productStockTextFieldPlaceholder)
    private lazy var productTextFiledStackView: BaseStackView = {
        let stackView = BaseStackView(arrangedSubviews: [
            self.productNameTextField,
            self.productOriginPriceStackView,
            self.productDiscountedPriceTextField,
            self.productStockTextField
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = CGFloat(10)
        stackView.alignment = .leading
        return stackView
    }()

    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = Constant.productDescriptionTextViewPlaceholder
        textView.textColor = .systemGray4
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.keyboardType = .default
        return textView
    }()

    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(self.pressCancelButton(_:))
        )
        return button
    }()

    private lazy var registerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(self.pressRegisterButton(_:))
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backButtonDisplayMode = .minimal
        self.navigationItem.title = self.navigationTitle
        self.navigationItem.leftBarButtonItem = self.cancelButton
        self.navigationItem.rightBarButtonItem = self.registerButton
        self.setTextFieldAndTextViewDelegate()
        self.bindAllConstraints()
        self.productViewModel.product(productId: self.product?.id)
        self.setViewModel()
    }

    @objc func pressAddImageButton(_ sender: UIButton) {
        self.showImagePickerControlActionSheet()
    }

    @objc func changeProductPriceSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case ProductPriceSegmentValue.krw.rawValue:
            print("krw")
        case ProductPriceSegmentValue.usd.rawValue:
            print("usd")
        default:
            break
        }
    }

    @objc func pressCancelButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func pressRegisterButton(_ sender: UIBarButtonItem) {
        guard self.registrationImageViewCount > 0 else {
            self.showAlert(title: "이미지를 하나 이상 등록하세요", message: nil)
            return
        }

        guard let productName = self.productNameTextField.text,
            let productDescription = self.productDescriptionTextView.text,
            productDescription != Constant.productDescriptionTextViewPlaceholder,
            let productOriginPriceText = self.productOriginPriceTextField.text,
            let productOriginPrice = Double(productOriginPriceText),
            let productDiscountedPriceText = self.productDiscountedPriceTextField.text,
            let productDiscountedPrice = Double(productDiscountedPriceText),
            let productStockText = self.productStockTextField.text,
            let productStock = Int(productStockText)
        else {
            self.showAlert(title: "입력란을 전부 채워주세요", message: nil)
            return
        }

        let postProduct = PostProduct(
            name: productName,
            descriptions: productDescription,
            price: productOriginPrice,
            currency: self.productPriceSegmentControl.selectedSegmentIndex == ProductPriceSegmentValue.krw.rawValue ? "KRW" : "USD",
            discountedPrice: productDiscountedPrice,
            stock: productStock,
            secret: Constant.secret
        )

        let productImages: [UIImage?] = self.registrationImageViewArray.enumerated()
            .filter { (index: Int, element: UIImageView) -> Bool in
                index < self.registrationImageViewCount
            }
            .map { (_: Int, element: UIImageView) -> UIImage? in
                element.image
            }
        if self.navigationTitle == "상품등록" {
            self.productViewModel.addProduct(postProduct: postProduct, productImages: productImages)
        } else {
            guard let productId = self.product?.id else { return }
            
            self.productViewModel.updateProduct(productId: productId, postProduct: postProduct, productImages: productImages)
        }
    }

    private func setViewModel() {
        self.productViewModel.addedProduct = { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.delegate?.modify()
                self.navigationController?.popViewController(animated: true)
            }
        }

        self.productViewModel.updateView = { [weak self] in
            guard let self = self else { return }

            self.product = self.productViewModel.product
            DispatchQueue.main.async {
                self.setProductInfo(product: self.product)
            }
        }

        self.productViewModel.updateImage = { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                let productImage = self.productViewModel.productImage
                self.registrationImageViewArray[self.registrationImageViewCount].image = productImage
                self.registrationImageViewArray[self.registrationImageViewCount].isHidden = false
                self.registrationImageViewCount += 1
            }
        }
    }

    private func setProductInfo(product: Product?) {
        guard let product = product else { return }

        self.addImageButton.isHidden = true
        self.productNameTextField.text = product.name
        self.productOriginPriceTextField.text = String(product.price)
        self.productDiscountedPriceTextField.text = String(product.discountedPrice)
        self.productStockTextField.text = String(product.stock)
        self.productDescriptionTextView.text = product.description

        if product.currency == "KRW" {
            self.productPriceSegmentControl.selectedSegmentIndex = ProductPriceSegmentValue.krw.rawValue
        } else {
            self.productPriceSegmentControl.selectedSegmentIndex = ProductPriceSegmentValue.usd.rawValue
        }

        guard let productImages = product.images else { return }

        for image in productImages {
            self.productViewModel.productImage(url: image.url)
        }
    }

    private func setTextFieldAndTextViewDelegate() {
        self.productNameTextField.delegate = self
        self.productOriginPriceTextField.delegate = self
        self.productDiscountedPriceTextField.delegate = self
        self.productStockTextField.delegate = self
        self.productDescriptionTextView.delegate = self
    }

    private func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK - UITextFieldDelegate
extension ProductEditViewController: UITextFieldDelegate {

}

// MARK - UITextViewDelegate
extension ProductEditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constant.productDescriptionTextViewPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Constant.productDescriptionTextViewPlaceholder
            textView.textColor = .systemGray4
        }
    }
}


// MARK - bindConstraints
extension ProductEditViewController {
    private func createRegistrationImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.isHidden = true
        return imageView
    }

    private func createProductTextField(placeholer: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholer
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        return textField
    }

    private func bindAllConstraints() {
        self.view.layer.cornerRadius = CGFloat(12.0)
        self.view.layer.borderColor = UIColor.gray.cgColor
        self.view.layer.borderWidth = CGFloat(1.0)

        self.bindRegistrationImageStackViewConstraints()
        self.bindProductTextFiledStackViewConstraints()
        self.bindProductDescriptionTextViewConstraints()
    }

    private func bindRegistrationImageStackViewConstraints() {
        self.view.addSubview(self.registrationImageScrollView)
        self.registrationImageScrollView.addSubview(self.registrationImageStackView)
        let contentLayoutGuide = self.registrationImageScrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            self.registrationImageView1.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            self.registrationImageView2.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            self.registrationImageView3.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            self.registrationImageView4.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            self.registrationImageView5.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            self.addImageButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),

            self.registrationImageScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.registrationImageScrollView.trailingAnchor.constraint(lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.registrationImageScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.registrationImageScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -32),

            self.registrationImageStackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            self.registrationImageStackView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            self.registrationImageStackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            self.registrationImageStackView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),

            self.registrationImageStackView.heightAnchor.constraint(equalTo: self.registrationImageScrollView.heightAnchor)
       ])
    }

    private func bindProductTextFiledStackViewConstraints() {
        self.view.addSubview(self.productTextFiledStackView)
        NSLayoutConstraint.activate([
            self.productTextFiledStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.productTextFiledStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.productTextFiledStackView.topAnchor.constraint(equalTo: self.registrationImageStackView.bottomAnchor, constant: 16),
            self.productTextFiledStackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.2),

            self.productNameTextField.leadingAnchor.constraint(equalTo: self.productTextFiledStackView.leadingAnchor),
            self.productNameTextField.trailingAnchor.constraint(equalTo: self.productTextFiledStackView.trailingAnchor),
            self.productOriginPriceTextField.leadingAnchor.constraint(equalTo: self.productTextFiledStackView.leadingAnchor),
            self.productOriginPriceTextField.widthAnchor.constraint(equalTo: self.productTextFiledStackView.widthAnchor, multiplier: 0.65),
            self.productPriceSegmentControl.trailingAnchor.constraint(equalTo: self.productTextFiledStackView.trailingAnchor),
            self.productDiscountedPriceTextField.leadingAnchor.constraint(equalTo: self.productTextFiledStackView.leadingAnchor),
            self.productDiscountedPriceTextField.trailingAnchor.constraint(equalTo: self.productTextFiledStackView.trailingAnchor),
            self.productStockTextField.leadingAnchor.constraint(equalTo: self.productTextFiledStackView.leadingAnchor),
            self.productStockTextField.trailingAnchor.constraint(equalTo: self.productTextFiledStackView.trailingAnchor)
       ])
    }

    private func bindProductDescriptionTextViewConstraints() {
        self.view.addSubview(self.productDescriptionTextView)
        NSLayoutConstraint.activate([
            self.productDescriptionTextView.leadingAnchor.constraint(equalTo: self.productTextFiledStackView.leadingAnchor),
            self.productDescriptionTextView.trailingAnchor.constraint(equalTo: self.productTextFiledStackView.trailingAnchor),
            self.productDescriptionTextView.topAnchor.constraint(equalTo: self.productTextFiledStackView.bottomAnchor, constant: 16),
            self.productDescriptionTextView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -16)
       ])
    }
}

// MARK - UIImagePickerController
extension ProductEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControlActionSheet() {
        let photoLibraryAction = UIAlertAction(title: "사진 선택하기", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "사진 촬영하기", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard self.registrationImageViewCount < 5 else {
            self.showAlert(title: "등록 가능한 이미지개수를 초과했습니다", message: nil)
            return
        }

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.registerImage(image: editedImage)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.registerImage(image: originalImage)
        }

        dismiss(animated: true, completion: nil)
    }

    func registerImage(image: UIImage) {
        self.registrationImageViewArray[self.registrationImageViewCount].image = image
        self.registrationImageViewArray[self.registrationImageViewCount].isHidden = false
        self.registrationImageViewCount += 1
    }
}
