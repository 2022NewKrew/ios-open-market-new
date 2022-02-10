import UIKit

class ProductDetailView: UIStackView {
    let productImage = SwipeImageView()
    
    let productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let productStock: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let productDescription: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isEditable = false
        return textView
    }()
    
    lazy var productPriceAndStockView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productStock, productPrice])
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var productInformationView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productName, productPriceAndStockView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .vertical
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .top
        self.distribution = .fill
        self.spacing = 10
        self.addArrangedSubviews([productImage, productInformationView, productDescription])
        productInformationView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        productImage.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        productImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        productDescription.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureData(data: Product) {
        if let images = data.images {
            productImage.setSourceData(source: images)
        }
        productName.text = data.name
        productStock.text = "남은 수량: \(data.stock)"
        productPrice.text = "\(data.currency) \(data.price)\n\(data.currency) \(data.discountedPrice)"
        productPrice.markDiscountPrice(target: "\(data.currency) \(data.price)")
        productDescription.text = data.description
        productDescription.sizeToFit()
    }
}
