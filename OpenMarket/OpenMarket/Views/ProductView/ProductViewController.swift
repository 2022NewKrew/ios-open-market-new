//
//  ProductViewController.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/02.
//

import UIKit

class ProductViewController: UIViewController {
    var navigationTitle: String?
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
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
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
        stackView.alignment = .leading
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
        self.bindAllConstraints()
    }

    @objc func pressAddImageButton(_ sender: UIButton) {
        // add image
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
        // add or update product
        print(#function)
    }

    private func createRegistrationImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.image = UIImage(systemName: "pencil")
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
