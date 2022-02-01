//
//  OpenMarketProductListCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import UIKit

class OpenMarketProductListCell: UICollectionViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var notDiscountedPriceLabel: UILabel!
    @IBOutlet weak var sellingPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    private var isBorderApplied: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        self.notDiscountedPriceLabel.attributedText = self.notDiscountedPriceLabel.text?.strikeThrough()
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 32.0).isActive = true
    }
    
    func configure(of product: OpenMarketProduct) {
        self.productNameLabel.text = product.name ?? Constants.unknwon
        self.stockLabel.text = "잔여수량 : \(product.stock ?? 0)"
        
        guard let price = product.price else {
            self.notDiscountedPriceLabel.isHidden = true
            self.sellingPriceLabel.text = Constants.unknwon
            return
        }
        
        let currecny = product.currency ?? .krw
        
        guard let discount = product.discountedPrice,
              discount != 0 else {
                  self.notDiscountedPriceLabel.isHidden = true
                  self.sellingPriceLabel.text = currecny.priceString(of: price)
                  return
              }
        
        self.notDiscountedPriceLabel.text = currecny.priceString(of: price)
        self.sellingPriceLabel.text = currecny.priceString(of: price - discount)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = UIImage(named: Constants.loadingImageName)
        self.notDiscountedPriceLabel.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isBorderApplied {
            self.contentView.layer.addBorder([.bottom], color: .lightGray, borderWidth: 1)
            isBorderApplied = true
        }
    }
}
