//
//  UIImageView+Extension.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/26.
//

import UIKit

extension UIImageView {
    func loadImage(urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
                  self.image = nil
                  return
              }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                self.image = nil
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
