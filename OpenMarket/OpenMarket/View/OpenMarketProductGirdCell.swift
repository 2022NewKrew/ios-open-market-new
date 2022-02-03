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
    private static let imageViewTopBottomSpacing = 8.0
    private static let priceStackViewTopBottomSpacing = 6.0
    private static let stockLabelBottomSpacing = 4.0
    private static let priceStackViewSpacing = 4.0
    
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
//        self.containerView.translatesAutoresizingMaskIntoConstraints = false
//        let spacing = Constants.openMarketPrdouctCellLeadingTrailingInset * 2.0 + Constants.openMarketProductGridCellMinimumInterItemSpacing
//        self.containerView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.size.width - spacing) / 2.0).isActive = true
        
//        self.priceStackView.translatesAutoresizingMaskIntoConstraints = false
//        self.priceStackView.heightAnchor.constraint(equalToConstant: Self.calculateStackViewHeight()).isActive = true
    }
    
    private static func calculateStackViewHeight() -> CGFloat {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = Constants.unknwon
        label.sizeToFit()
        return label.frame.height * 2.0 + priceStackViewSpacing
    }
    
    static func cellForWidth(safeAreaWidth: CGFloat) -> CGFloat {
        let width =  (safeAreaWidth - Constants.openMarketPrdouctCellLeadingTrailingInset * 2.0 - Constants.openMarketProductGridCellMinimumInterItemSpacing) / 2.0
        return width
    }
    
    static func cellForHeight(safeAreaWidth: CGFloat) -> CGFloat {
        let imageViewHeight = Self.cellForWidth(safeAreaWidth: safeAreaWidth) * 0.8
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        nameLabel.text = Constants.unknwon
        nameLabel.sizeToFit()
        let nameLabelHeight = nameLabel.frame.height
        
        let priceStackViewHeight = calculateStackViewHeight()
        
        let stockLabel = UILabel()
        stockLabel.font = UIFont.preferredFont(forTextStyle: .body)
        stockLabel.text = Constants.unknwon
        stockLabel.sizeToFit()
        let stockLabelHeight = stockLabel.frame.height
        
        let height = ceil(imageViewTopBottomSpacing * 2.0 + imageViewHeight + nameLabelHeight + priceStackViewTopBottomSpacing * 2.0 + priceStackViewHeight + stockLabelHeight + stockLabelBottomSpacing)
        
        return height
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = UIImage(named: Constants.loadingImageName)
        self.notDiscountedPriceLabel.isHidden = false
        self.stockLabel.textColor = .systemGray
    }
}
