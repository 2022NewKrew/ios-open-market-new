import UIKit

class ProductEditView: UIStackView {
    lazy var images: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(addImage)
        return scrollView
    }()
    
    let addImage: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.backgroundColor = .systemGray5
        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
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
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    let productCurrency: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(segmentedControl:)), for: .valueChanged)
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
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 3
        return textField
    }()
    
    let productStock: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .center
        self.distribution = .fill
        self.spacing = 10
        self.addArrangedSubview(images)
        self.addArrangedSubview(productName)
        self.addArrangedSubview(productPriceView)
        self.addArrangedSubview(productDiscountPrice)
        self.addArrangedSubview(productStock)
        self.addArrangedSubview(productDetail)
        addImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        images.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        images.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
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
}
