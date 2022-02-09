import Foundation
import UIKit

protocol ProductEditable {
    var imageScrollView: UIScrollView { get }
    var imageContentView: UIStackView { get }
    var productName: UITextField { get }
    var productPrice: UITextField { get }
    var productCurrency: UISegmentedControl { get }
    var productPriceView: UIStackView { get }
    var productDiscountPrice: UITextField { get }
    var productStock: UITextField { get }
    var productDetail: UITextView { get }
}

class ProductEditableView: UIStackView, ProductEditable {
    let imageScrollView = UIScrollView()
    
    let addImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.backgroundColor = .systemGray5
        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(ProductAddViewController.presentAlbum), for: .touchUpInside)
        return button
    }()
    
    lazy var imageContentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(addImageButton)
        return stackView
    }()
    
    let productName: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "상품명"
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    let productPrice: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "상품가격"
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    let productCurrency: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    lazy var productPriceView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productPrice, productCurrency])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    let productDiscountPrice: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    let productStock: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    let productDetail: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.text = "temp"
        return textView
    }()
    
    var imageData: [Data] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .center
        self.distribution = .fill
        self.spacing = 10
        self.addArrangedSubview(imageScrollView)
        self.addArrangedSubview(productName)
        self.addArrangedSubview(productPriceView)
        self.addArrangedSubview(productDiscountPrice)
        self.addArrangedSubview(productStock)
        self.addArrangedSubview(productDetail)
        
        setupScrollView()
        
        addImageButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        productName.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        productPriceView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        productPrice.trailingAnchor.constraint(equalTo: productCurrency.leadingAnchor, constant: -5).isActive = true
        productDiscountPrice.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        productStock.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        productDetail.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageScrollView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        let containerView = UIView()
        imageScrollView.addSubview(containerView)
        containerView.constraintsToFit(imageScrollView.contentLayoutGuide)
        containerView.heightAnchor.constraint(equalTo: imageScrollView.frameLayoutGuide.heightAnchor).isActive = true
        imageScrollView.addSubview(imageContentView)
        imageContentView.constraintsToFit(containerView)
    }

}
