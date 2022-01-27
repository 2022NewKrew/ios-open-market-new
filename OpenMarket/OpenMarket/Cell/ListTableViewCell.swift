import UIKit

class ListTableViewCell: UITableViewCell {
    // MARK: - property
    static let identifier = "ListCell"
    
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        return label
    }()
    
    let productStock: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    lazy var nameAndPriceStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productName, productPrice])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        return stackView
    }()
    
    lazy var stackOfInformations: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productImage, nameAndPriceStack, productStock])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    // MARK: - override functions
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - functions
    func setListCell(data: Product) {
        do {
            let imageData: Data = try Data(contentsOf: data.thumbnail)
            productImage.image = UIImage(data: imageData)
        } catch {}
        productName.text = data.name
        productStock.text = data.stock == 0 ? "품절" : "잔여수량: \(data.stock)"
        productStock.textColor = data.stock == 0 ? .systemOrange : .systemGray
        setPriceLabel(originalPrice: Int.init(data.price), currentPrice: Int.init(data.discountedPrice), currency: data.currency)
    }
    
    func setPriceLabel(originalPrice: Int, currentPrice: Int, currency: String) {
        let previousInformation = "\(currency) \(originalPrice)"
        let currentInformation = "\(currency) \(currentPrice)"
        if originalPrice == currentPrice {
            productPrice.text = currentInformation
            return
        }
        productPrice.text = previousInformation + " " + currentInformation
        productPrice.markDiscountPrice(target: previousInformation)
    }
    
    func setUpView() {
        contentView.addSubview(stackOfInformations)
        contentView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        productStock.widthAnchor.constraint(equalToConstant: 80).isActive = true
        stackOfInformations.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        stackOfInformations.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        stackOfInformations.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        stackOfInformations.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        productImage.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.1).isActive = true
    }
}

extension UILabel {
    func markDiscountPrice(target: String) {
        let fullText = self.text ?? ""
        let targetRange = (fullText as NSString).range(of: target)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemRed, range: targetRange)
        attributedString.addAttribute(NSAttributedString.Key.strokeColor, value: UIColor.systemRed, range: targetRange)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: targetRange)
        self.attributedText = attributedString
    }
}
