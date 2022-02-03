//
//  OpenMarketProductListCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import UIKit

class OpenMarketProductListCell: UICollectionViewCell, OpenMarketProductCellType {
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
        let insets = Constants.openMarketPrdouctCellLeadingTrailingInset * 2.0
        self.containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - insets).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = UIImage(named: Constants.loadingImageName)
        self.notDiscountedPriceLabel.isHidden = false
        self.stockLabel.textColor = .systemGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isBorderApplied {
            self.contentView.layer.addBorder([.bottom], color: .lightGray, borderWidth: 1)
            isBorderApplied = true
        }
    }
}
