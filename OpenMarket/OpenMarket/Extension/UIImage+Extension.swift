//
//  UIImage+Extension.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/04.
//

import UIKit

extension UIImage {
    func jpeg(maximumSizeKb: CGFloat) -> Data? {
        var compactCompressionQuality: CGFloat = 0.0
        var lowIndex = 0
        var highIndex = 100
        
        while lowIndex <= highIndex {
            let midIndex = (lowIndex + highIndex) / 2
            let compressionQuality = CGFloat(midIndex) / 100.0
            
            guard let imageData = self.jpegData(compressionQuality: compressionQuality) else {
                return nil
            }
            
            let currentSize = CGFloat(imageData.count) / 1024.0
            
            if currentSize > maximumSizeKb {
                highIndex = midIndex - 1
            } else if currentSize < maximumSizeKb {
                lowIndex = midIndex + 1
                compactCompressionQuality = compressionQuality
            } else {
                return imageData
            }
        }
        
        return self.jpegData(compressionQuality: compactCompressionQuality) ?? nil
    }
}
