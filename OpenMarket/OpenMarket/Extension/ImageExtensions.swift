import Foundation
import UIKit

extension UIImage {
    func resizeImage(scale: Double) -> UIImage? {
        let size = self.size
        let newSize = CGSize(width: size.width / scale, height: size.height / scale)
        let rect = CGRect(origin: .zero, size: newSize)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
