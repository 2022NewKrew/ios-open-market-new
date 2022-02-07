//
//  ProductListContentView.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import UIKit

class ProductListCell: UICollectionViewCell{
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productThumbnailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        discountedPriceLabel.isHidden = true
    }
    
    func configureUI(product: Product) {
        productNameLabel.text = product.name
        
        if product.discountedPrice != 0 {
            let text = "\(product.currency.rawValue) \(product.price)"
            discountedPriceLabel.isHidden = false
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            discountedPriceLabel.attributedText = attributeString
        }
        
        productPriceLabel.text = "\(product.currency.rawValue) \(product.price - product.discountedPrice)"
        
        stockLabel.textColor = product.stock == 0 ? .systemOrange : .lightGray
        stockLabel.text = product.stock == 0 ? "품절" : "잔여수량: \(product.stock)"
        
        guard let thumbnailURL = product.thumbnailURL else { return }
        ImageCache.shared.load(url: thumbnailURL as NSURL) { image in
            DispatchQueue.main.async {
                self.productThumbnailImageView.image = image
            }
        }
    }
}


