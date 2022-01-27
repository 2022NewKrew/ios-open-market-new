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
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    let productStock: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    lazy var nameAndPriceStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productName, productPrice])
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
        stackView.distribution = .equalSpacing
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
        // Initialization code
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
        productPrice.text = "\(data.price)"
//        
    }
    
    func setUpView() {
        addSubview(stackOfInformations)
        stackOfInformations.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        stackOfInformations.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        stackOfInformations.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        stackOfInformations.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        productImage.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.1).isActive = true
    }

}
