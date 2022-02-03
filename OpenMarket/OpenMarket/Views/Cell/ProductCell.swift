//
//  ProductCell.swift
//  OpenMarket
//
//  Created by 이승주 on 2022/02/02.
//

import UIKit

protocol ProductCell: UICollectionViewCell {
    func updateCell(product: Product?)
}
