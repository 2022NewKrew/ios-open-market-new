import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    static let identifier = "GridCell"
    
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        return imageView
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    let stock: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        return label
    }()
    
    lazy var gridStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImage, name, productPrice, stock])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(gridStack)
        gridStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        gridStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        gridStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        gridStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        productImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func setupCell(data: Product) {
        do {
            let imageData: Data = try Data(contentsOf: data.thumbnail)
            productImage.image = UIImage(data: imageData)
        } catch {}
        name.text = data.name
        stock.text = data.stock == 0 ? "품절" : "잔여수량: \(data.stock)"
        stock.textColor = data.stock == 0 ? .systemOrange : .systemGray
        setPriceLabel(originalPrice: Int.init(data.price), currentPrice: Int.init(data.discountedPrice), currency: data.currency)
    }
    
    func setPriceLabel(originalPrice: Int, currentPrice: Int, currency: String) {
        let previousInformation = "\(currency) \(originalPrice)"
        let currentInformation = "\(currency) \(currentPrice)"
        if originalPrice == currentPrice {
            productPrice.text = currentInformation
            return
        }
        productPrice.text = previousInformation + "\n" + currentInformation
        productPrice.changeFont(target: previousInformation)
        
    }
}
