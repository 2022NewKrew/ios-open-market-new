//
//  ProductListContentView.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import UIKit

@available(iOS 14.0, *)
class ProductListContentView: UIView, UIContentView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var productThumbnailImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    private var currentConfiguration: ProductContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? ProductContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    
    init(configuration: ProductContentConfiguration) {
        super.init(frame: .zero)
        loadNib()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("\(ProductListContentView.self)", owner: self, options: nil)
        addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
        ])
    }
    
    private func apply(configuration: ProductContentConfiguration) {
        guard currentConfiguration != configuration else { return }
        print("apply called")
        currentConfiguration = configuration
        
        productNameLabel.text = configuration.productName
        
        if let discountedPrice = configuration.discountedPrice {
            let text = "\(configuration.currency?.rawValue ?? "KRW") \(discountedPrice)"
            discountedPriceLabel.isHidden = false
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            discountedPriceLabel.attributedText = attributeString
        }
        
        productPriceLabel.text = "\(configuration.currency?.rawValue ?? "KRW") \(configuration.price ?? 0)"
        
        if let stock = configuration.stock {
            stockLabel.textColor = stock == 0 ? .systemOrange : .lightGray
            stockLabel.text = stock == 0 ? "품절" : "\(stock)"
        }
        
        guard let thumbnailURL = configuration.thumbnailURL else { return }
        ImageCache.shared.load(url: thumbnailURL as NSURL) { image in
            self.productThumbnailImageView.image = image
        }
    }
}


