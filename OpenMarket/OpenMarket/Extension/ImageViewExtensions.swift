import Foundation
import UIKit

extension UIImageView {
    func setImage(image: Image) {
        if let url = URL(string: image.url),
           let imageData: Data = try? Data(contentsOf: url)  {
            self.image = UIImage(data: imageData)
        }
    }
}
