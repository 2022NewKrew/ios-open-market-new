import UIKit

class ProductEditView: UIStackView {
    let imageScrollView = UIScrollView()
    
    lazy var imageContentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(addImageButton)
        return stackView
    }()
    
    let addImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.backgroundColor = .systemGray5
        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(ProductEditViewController.presentAlbum), for: .touchUpInside)
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
    
    func addImage(image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        imageContentView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        // nested.. 
        if let data = image.pngData() {
            let scale = Double.init(data.count / 1048576)
            if scale > 1 {
                if let newImage = image.resizeImage(scale: scale) {
                    imageView.image = newImage
                    imageData.append(newImage.pngData()!)
                    return
                }
            }
            imageData.append(data)
        }
    }
    
    func saveProduct() {
        var data: [String: String] = [:]
        data["name"] = productName.text
        data["descriptions"] = productDetail.text
        data["price"] = productPrice.text
        data["currency"] = productCurrency.selectedSegmentIndex == 0 ? "KRW" : "USD"
        data["discounted_price"] = productDiscountPrice.text
        data["stock"] = productStock.text
        OpenMarketAPI.shared.addProduct(data: &data, images: &imageData)
    }
}
