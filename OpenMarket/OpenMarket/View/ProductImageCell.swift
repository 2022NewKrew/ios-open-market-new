//
//  ProductImageCell.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/07.
//

import UIKit

class ProductImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(_ image: UIImage?){
        imageView.image = image
    }
}
