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
    private static let labelSpacing = 5.0
    private static let topBottomSpacing = 8.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    private func setupUI() {
        self.notDiscountedPriceLabel.attributedText = self.notDiscountedPriceLabel.text?.strikeThrough()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = UIImage(named: Constants.loadingImageName)
        self.notDiscountedPriceLabel.isHidden = false
        self.stockLabel.textColor = .systemGray
    }
    
    static func cellForWidth(safeAreaWidth: CGFloat) -> CGFloat {
        let width =  safeAreaWidth - Constants.openMarketPrdouctCellLeadingTrailingInset * 2.0
        return width
    }
    
    static func cellForHeight(safeAreaWidth: CGFloat) -> CGFloat {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        nameLabel.text = Constants.unknwon
        nameLabel.sizeToFit()
        
        let priceLabel = UILabel()
        priceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        priceLabel.text = Constants.unknwon
        priceLabel.sizeToFit()
        
        let labelHeight = nameLabel.frame.height + priceLabel.frame.height + Self.topBottomSpacing * 2.0 + Self.labelSpacing
        let imageViewHeight = safeAreaWidth * 0.1 + Self.topBottomSpacing * 2.0
        
        return labelHeight > imageViewHeight ? labelHeight : imageViewHeight
    }
}
