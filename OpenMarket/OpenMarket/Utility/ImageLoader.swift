//
//  ImageLoader.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/31.
//

import UIKit

struct ImageLoader {
    static func loadImage(urlString: String?, completion: @escaping  (UIImage) -> ()) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
                  return
              }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                      return
                  }
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
