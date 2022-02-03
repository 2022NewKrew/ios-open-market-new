//
//  OpenMarketProductGirdCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/01.
//

import UIKit

class OpenMarketProductGirdCell: UICollectionViewCell, OpenMarketProductCellType {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var notDiscountedPriceLabel: UILabel!
    @IBOutlet weak var sellingPriceLabel: UILabel!
    @IBOutlet weak var priceStackView: UIStackView!
    private let priceStackViewSpacing = 4.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        self.notDiscountedPriceLabel.attributedText = self.notDiscountedPriceLabel.text?.strikeThrough()
        self.setupConstraint()
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 16
        
    }
    
    private func setupConstraint() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        let spacing = Constants.openMarketPrdouctCellLeadingTrailingInset * 2.0 + Constants.openMarketProductGridCellMinimumInterItemSpacing
        self.containerView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.size.width - spacing) / 2.0).isActive = true
        
        self.priceStackView.translatesAutoresizingMaskIntoConstraints = false
        self.priceStackView.heightAnchor.constraint(equalToConstant: self.calculateStackViewHeight()).isActive = true
    }
    
    private func calculateStackViewHeight() -> CGFloat {
        self.sellingPriceLabel.sizeToFit()
        let height = ceil(sellingPriceLabel.frame.height * 2.0 + self.priceStackView.spacing)
        return height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = UIImage(named: Constants.loadingImageName)
        self.notDiscountedPriceLabel.isHidden = false
        self.stockLabel.textColor = .systemGray
    }
}
