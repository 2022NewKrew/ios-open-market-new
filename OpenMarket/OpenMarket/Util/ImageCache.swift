//
//  ImageCache.swift
//  OpenMarket
//
//  Created by kakao on 2022/01/27.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    var placeholderImage = UIImage(systemName: "rectangle")!
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func load(url: NSURL,completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = image(url: url) {
            completion(cachedImage)
        }
        
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            guard let data = data, let image = UIImage(data: data), error == nil else { return }
            self.cachedImages.setObject(image, forKey: url)
            completion(image)
        })
        .resume()
    }
    
}
