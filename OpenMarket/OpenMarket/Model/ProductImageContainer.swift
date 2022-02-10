//
//  ProductImageContainer.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/08.
//

import UIKit

typealias Images = ProductImageContainer

struct ProductImageContainer {
    private var imageContainer: [UIImage?]
    let maxImageCount: Int
    private var currentImageCount = 0
    private var currentImageHeight = 0
    
    var images: [UIImage] {
        var images: [UIImage] = []
        for i in 0 ..< currentImageCount {
            if let image = self.imageContainer[i] {
                images.append(image)
            }
        }
        return images
    }
    
    var count: Int {
        return self.currentImageCount
    }
    
    var isEmpty: Bool {
        return self.currentImageCount == 0
    }
    
    var isFull: Bool {
        return self.currentImageCount == self.maxImageCount
    }
    
    init(maxImageCount: Int) {
        self.maxImageCount = maxImageCount
        self.imageContainer = Array(repeating: nil, count: maxImageCount)
    }
    
    mutating func addImage(_ image: UIImage) -> Bool {
        if self.isFull {
            return false
        }
        let index = self.currentImageCount
        guard self.imageContainer[index] == nil else {
            return false
        }
        self.imageContainer[index] = image
        self.currentImageCount += 1
        return true
    }
    
    mutating func updateImage(_ image: UIImage, at index: Int) -> Bool {
        guard index < self.currentImageCount else {
            return false
        }
        self.imageContainer[index] = image
        return true
    }
    
    mutating func deleteImage(at index: Int) -> Bool {
        guard index < self.currentImageCount else {
            return false
        }
        for i in index + 1 ..< self.currentImageCount {
            self.imageContainer[i - 1] = self.imageContainer[i]
        }
        self.currentImageCount -= 1
        self.imageContainer[currentImageCount] = nil
        return true
    }
}
